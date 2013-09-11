//
//  TLBAppDelegate.h
//  TruliaCodeTestiPad
//
//  Created by Neha Shevade on 9/11/13.
//  Copyright (c) 2013 Trulia, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
