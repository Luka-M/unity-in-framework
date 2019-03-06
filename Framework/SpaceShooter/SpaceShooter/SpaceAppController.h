//
//  SpaceAppController.h
//  SpaceShooter
//
//  Created by Luka Mijatovic on 06/03/2019.
//  Copyright © 2019 KodBiro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpaceAppController : NSObject

+ (instancetype)sharedController;
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions;
- (void)applicationWillResignActive:(UIApplication*)application;
- (void)applicationDidBecomeActive:(UIApplication*)application;
- (void)applicationWillEnterForeground:(UIApplication*)application;
- (void)applicationWillTerminate:(UIApplication*)application;
- (UIView*)unityView;

@end

NS_ASSUME_NONNULL_END
