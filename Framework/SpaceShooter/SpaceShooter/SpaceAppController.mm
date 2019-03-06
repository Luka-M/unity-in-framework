//
//  SpaceAppController.m
//  SpaceShooter
//
//  Created by Luka Mijatovic on 06/03/2019.
//  Copyright © 2019 KodBiro. All rights reserved.
//

#import "SpaceAppController.h"
#import "SpaceUnityAppController.h"
#import "UnityMain.h"
#import "fishhook.h"
#import <mach-o/dyld.h>

int (*_NSGetExecutablePath_original)(char*, uint32_t*);

int _NSGetExecutablePath_patched(char* path, uint32_t* size) {
    
    NSString* imageName;
    unsigned long imageCount = _dyld_image_count();
    for(uint32_t i = 0; i < imageCount; i++) {
        const char *dyld = _dyld_get_image_name(i);
        imageName = [[NSString alloc] initWithUTF8String:dyld];
        if ([imageName hasSuffix:@"SpaceShooter.framework/SpaceShooter"]) {
            break;
        }
    }
    
    if (path == NULL) {
        *size = (uint32_t)[imageName length];
    } else {
        strcpy(path, [imageName UTF8String]);
    }
    
    return 0;
}


// App states
const NSInteger APP_STATE_INITIAL = 0;
const NSInteger APP_STATE_FINISHED_LAUNCHING = 1;
const NSInteger APP_STATE_BECOME_ACTIVE = 2;
const NSInteger APP_STATE_RESIGNED_ACTIVE = 3;

@interface SpaceAppController()
@property (nonatomic, strong) SpaceUnityAppController* unityAppController;
@property (nonatomic, assign) NSInteger appState;
@end

@implementation SpaceAppController

+ (instancetype)sharedController {
    static SpaceAppController* sharedController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        rebind_symbols((struct rebinding[1]) {
            {"_NSGetExecutablePath", (void*)_NSGetExecutablePath_patched, (void **)&_NSGetExecutablePath_original}
        }, 1);

        sharedController = [[[self class] alloc] init];
    });
    return sharedController;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _appState = APP_STATE_INITIAL;
        
        // Grab the arguments used to start the process (apparently Unity needs them)
        NSArray* arguments = [[NSProcessInfo processInfo] arguments];
        NSInteger count = [arguments count];
        char **array = (char **)malloc((count + 1) * sizeof(char*));
        
        for (NSInteger i = 0; i < count; i++) {
            array[i] = strdup([[arguments objectAtIndex:i] UTF8String]);
        }
        array[count] = NULL;
        char** argv = array;
        
        // call UnityMain which is actually the code from the Unity generated main.mm
        UnityInitialize(1, argv);
        
        // Intialize the UnityAppController instance
        _unityAppController = [[SpaceUnityAppController alloc] init];
    }
    return self;
}


- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    if (self.appState != APP_STATE_INITIAL) {
        return YES;
    }
    self.appState = APP_STATE_FINISHED_LAUNCHING;
    return [self.unityAppController application:application didFinishLaunchingWithOptions:launchOptions];
}
- (void)applicationWillResignActive:(UIApplication*)application {
    if (self.appState != APP_STATE_BECOME_ACTIVE) {
        return;
    }
    self.appState = APP_STATE_RESIGNED_ACTIVE;
    [self.unityAppController applicationWillResignActive:application];
}
- (void)applicationDidBecomeActive:(UIApplication*)application {
    if (self.appState != APP_STATE_FINISHED_LAUNCHING && self.appState != APP_STATE_RESIGNED_ACTIVE) {
        return;
    }
    self.appState = APP_STATE_BECOME_ACTIVE;
    [self.unityAppController applicationDidBecomeActive:application];
}
- (void)applicationWillEnterForeground:(UIApplication*)application {
    [self.unityAppController applicationWillEnterForeground:application];
}
- (void)applicationWillTerminate:(UIApplication*)application {
    [self.unityAppController applicationWillTerminate:application];
}
- (UIView*)unityView {
    return (UIView*)self.unityAppController.unityView;
}


@end
