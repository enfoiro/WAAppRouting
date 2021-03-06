//
//  AppDelegate.m
//  PPRevealSample
//
//  Created by Marian Paul on 20/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "AppDelegate.h"
#import <PPRevealSideViewController/PPRevealSideViewController.h>
#import <WAAppRouting/WAAppRouting.h>

#import "WAList1ViewController.h"
#import "WALeftMenuViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) WAAppRouter *router;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Init the stack
    WAList1ViewController *list1                         = [[WAList1ViewController alloc] init];
    UINavigationController *list1NavigationController    = [[UINavigationController alloc] initWithRootViewController:list1];
    PPRevealSideViewController *revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:list1NavigationController];
    
    WALeftMenuViewController *leftMenu = [[WALeftMenuViewController alloc] init];
    [revealSideViewController preloadViewController:leftMenu forSide:PPRevealSideDirectionLeft];
    
    // Important things to notice
    // When you are dealing with containers which are supposed to allocate the navigation controller on the fly, you should pass the presenting controller as the container and implement the protocol `WAAppRoutingContainerPresentationProtocol` to return a correct navigation controller
    
    // Init the router
    // Create the default router
    self.router = [WAAppRouter defaultRouter];
    
    // Create the paths
    [self.router.registrar registerAppRoutePath:@"list1{WAList1ViewController}/:itemID{WAList1DetailViewController}/extra{WAList1DetailExtraViewController}" presentingController:revealSideViewController];
    [self.router.registrar registerAppRoutePath:@"list2{WAList2ViewController}/:itemID{WAList2DetailViewController}" presentingController:revealSideViewController];
    [self.router.registrar registerAppRoutePath:@"modal{WAModalViewController}!" presentingController:nil];
    [self.router.registrar registerAppRoutePath:@"left{WALeftMenuViewController}" presentingController:revealSideViewController];

    self.window.rootViewController = revealSideViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"openURL: %@", URL);
    BOOL handleUrl = NO;

    if ([URL.scheme isEqualToString:@"pprevealexample"]) {
        handleUrl = [self.router handleURL:URL];
    }
    
    if (!handleUrl && ([URL.scheme isEqualToString:@"pprevealexample"])) {
        NSLog(@"Well, this one is not handled, consider displaying a 404");
    }
    
    return handleUrl;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

# pragma Mark - URL Handling

- (void)goTo:(NSString *)route, ... {
    va_list args;
    va_start(args, route);
    NSString *finalRoute = [[NSString alloc] initWithFormat:route arguments:args];
    va_end(args);
    
    [self application:(UIApplication *)self openURL:[NSURL URLWithString:finalRoute] sourceApplication:nil annotation:nil];
}
@end
