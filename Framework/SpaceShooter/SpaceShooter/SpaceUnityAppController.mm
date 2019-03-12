//
//  SpaceUnityAppController.m
//  SpaceShooter
//
//  Created by Luka Mijatovic on 06/03/2019.
//  Copyright © 2019 KodBiro. All rights reserved.
//

#import "SpaceUnityAppController.h"
#import "UnityAppController+Rendering.h"
#import "UnityAppController+ViewHandling.h"
#include "UnityViewControllerBase.h"
#import "DisplayManager.h"
#import "UnityView.h"
#import "Keyboard.h"
#import "SplashScreen.h"
#import "ActivityIndicator.h"
#import "OrientationSupport.h"

extern bool _unityAppReady;
extern bool _skipPresent;

@interface SpaceUnityAppController ()
- (void)updateAppOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation SpaceUnityAppController

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    ::printf("-> applicationDidFinishLaunching()\n");
    
    // send notfications
#if !PLATFORM_TVOS
    if (UILocalNotification* notification = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey])
        UnitySendLocalNotification(notification);
    
    if ([UIDevice currentDevice].generatesDeviceOrientationNotifications == NO)
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
#endif
    // UNITY FRAMEWORK CHANGES BEGIN
    UnityInitApplicationNoGraphics([[[NSBundle bundleForClass:[self class]] bundlePath] UTF8String]);
    // UNITY FRAMEWORK CHANGES END
    
    [self selectRenderingAPI];
    [UnityRenderingView InitializeForAPI: self.renderingAPI];
    
    // UNITY FRAMEWORK CHANGES BEGIN
    //_window         = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    // UNITY FRAMEWORK CHANGES END

    _unityView      = [self createUnityView];
    
    [DisplayManager Initialize];
    _mainDisplay    = [DisplayManager Instance].mainDisplay;
    [_mainDisplay createWithWindow: _window andView: _unityView];
    
    [self createUI];
    [self preStartUnity];
    
    // if you wont use keyboard you may comment it out at save some memory
    [KeyboardDelegate Initialize];
    
#if !PLATFORM_TVOS && DISABLE_TOUCH_DELAYS
    for (UIGestureRecognizer *g in _window.gestureRecognizers)
    {
        g.delaysTouchesBegan = false;
    }
#endif
    
    return YES;
}


- (void)createUI
{
    NSAssert(_unityView != nil, @"_unityView should be inited at this point");
    // UNITY FRAMEWORK CHANGES BEGIN
    //NSAssert(_window != nil, @"_window should be inited at this point");
    // UNITY FRAMEWORK CHANGES END

    _rootController = [self createRootViewController];
    
    [self willStartWithViewController: _rootController];
    
    NSAssert(_rootView != nil, @"_rootView  should be inited at this point");
    NSAssert(_rootController != nil, @"_rootController should be inited at this point");

    // UNITY FRAMEWORK CHANGES BEGIN
    //    [_window makeKeyAndVisible];
    // UNITY FRAMEWORK CHANGES END

    [UIView setAnimationsEnabled: NO];
    
    // TODO: extract it?

    // UNITY FRAMEWORK CHANGES BEGIN
    //   ShowSplashScreen(_window);
    // UNITY FRAMEWORK CHANGES END

#if UNITY_SUPPORT_ROTATION
    // to be able to query orientation from view controller we should actually show it.
    // at this point we can only show splash screen, so update app orientation after we started showing it
    // NB: _window.rootViewController = splash view controller (not _rootController)
    [self updateAppOrientation: ConvertToIosScreenOrientation(UIViewControllerOrientation(_window.rootViewController))];
#endif
    
    NSNumber* style = [[[NSBundle mainBundle] infoDictionary] objectForKey: @"Unity_LoadingActivityIndicatorStyle"];
    ShowActivityIndicator([SplashScreen Instance], style ? [style intValue] : -1);
    
    NSNumber* vcControlled = [[[NSBundle mainBundle] infoDictionary] objectForKey: @"UIViewControllerBasedStatusBarAppearance"];
    if (vcControlled && ![vcControlled boolValue])
        printf_console("\nSetting UIViewControllerBasedStatusBarAppearance to NO is no longer supported.\n"
                       "Apple actively discourages that, and all application-wide methods of changing status bar appearance are deprecated\n\n"
                       );
}


- (void)showGameUI
{
    HideActivityIndicator();
    HideSplashScreen();
    
    // make sure that we start up with correctly created/inited rendering surface
    // NB: recreateRenderingSurface won't go into rendering because _unityAppReady is false
#if UNITY_SUPPORT_ROTATION
    [self checkOrientationRequest];
#endif
    [_unityView recreateRenderingSurface];

    // UNITY FRAMEWORK CHANGES BEGIN
    // UI hierarchy
    //    [_window addSubview: _rootView];
    //    _window.rootViewController = _rootController;
    //    [_window bringSubviewToFront: _rootView];
    // UNITY FRAMEWORK CHANGES END

#if UNITY_SUPPORT_ROTATION
    // to be able to query orientation from view controller we should actually show it.
    // at this point we finally started to show game view controller. Just in case update orientation again
    [self updateAppOrientation: ConvertToIosScreenOrientation(UIViewControllerOrientation(_rootController))];
#endif
    
    // why we set level ready only now:
    // surface recreate will try to repaint if this var is set (poking unity to do it)
    // but this frame now is actually the first one we want to process/draw
    // so all the recreateSurface before now (triggered by reorientation) should simply change extents
    
    _unityAppReady = true;
    
    // why we skip present:
    // this will be the first frame to draw, so Start methods will be called
    // and we want to properly handle resolution request in Start (which might trigger surface recreate)
    // NB: we want to draw right after showing window, to avoid black frame creeping in
    
    _skipPresent = true;
    
    if (!UnityIsPaused())
        UnityRepaint();
    
    _skipPresent = false;
    [self repaint];
    
    [UIView setAnimationsEnabled: YES];
}
@end
