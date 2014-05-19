//
//  TLBSearchRequestController.m
//  TruliaCodeTestiPad
//
//  Copyright (c) 2013 Trulia, Inc. All rights reserved.
//

#import "TLBSearchRequestController.h"

@interface TLBSearchRequestController ()
@property (nonatomic, retain) NSMutableData *results;
@end

@implementation TLBSearchRequestController

@synthesize delegate = _delegate;
@synthesize results = _results;
@synthesize pageNumber = _pageNumber;

-(void)searchRequestWithTerm:(NSString *)searchQuery{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&resultFormat=text&start=%d&rsz=8", searchQuery, _pageNumber]]];
    NSLog(@"request url: %@", [NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&resultFormat=text&start=%d&rsz=8", searchQuery, _pageNumber]]);
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)dealloc
{
    [self.results release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSUrlConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.results = [[[NSMutableData alloc] initWithCapacity:1024] autorelease];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //TODO: Handle error appropriately here
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle: @"Connection Error"
                                                        message: @"Failed to fetch the data. Check your Internet connectivity"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil] autorelease];
    [alertView show];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.results appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:self.results options:NSJSONReadingAllowFragments error:&error];
    if (!JSONObject) {
        NSLog(@"There was an error: %@", error);
    }
    id responseData = [JSONObject objectForKey:@"responseData"];
    if ([responseData isKindOfClass:[NSDictionary class]]) {
        id results = [responseData objectForKey:@"results"];
        if ([results isKindOfClass:[NSArray class]]) {
            [self.delegate searchRequestController:self gotResults:results];
        }
    }
}

@end
