//
//  ViewController.m
//  SpaceApp
//
//  Created by Luka Mijatovic on 06/03/2019.
//  Copyright © 2019 KodBiro. All rights reserved.
//

#import "ViewController.h"
#import "SpaceAppController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIView* unityContainerView;
@property (nonatomic, strong) UIView* unityView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SpaceAppController sharedController] application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:[NSDictionary dictionary]];
    [[SpaceAppController sharedController] applicationDidBecomeActive:[UIApplication sharedApplication]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    

    self.unityView = [SpaceAppController sharedController].unityView;
    [self.unityContainerView addSubview:self.unityView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.unityView.frame = self.unityContainerView.bounds;
}


- (void)applicationWillResignActive {
    [[SpaceAppController sharedController] applicationWillResignActive:[UIApplication sharedApplication]];
}

- (void)applicationDidBecomeActive {
    [[SpaceAppController sharedController] applicationDidBecomeActive:[UIApplication sharedApplication]];
}

- (void)applicationWillEnterForeground {
    [[SpaceAppController sharedController] applicationWillEnterForeground:[UIApplication sharedApplication]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SpaceAppController sharedController] applicationWillResignActive:[UIApplication sharedApplication]];
}

@end
