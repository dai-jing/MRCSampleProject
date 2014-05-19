//
//  TLBSearchRequestController.h
//  TruliaCodeTestiPad
//
//  Copyright (c) 2013 Trulia, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TLBSearchRequestControllerDelegate
- (void)searchRequestController:(id)srchRequestController gotResults:(NSArray *)results;
@end

@interface TLBSearchRequestController : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic) int pageNumber;
@property (nonatomic, assign) id <TLBSearchRequestControllerDelegate> delegate;

-(void)searchRequestWithTerm:(NSString *)searchQuery;

@end
