//
//  TLBLargeImageViewController.m
//  TruliaCodeTestiPad
//
//  Created by JingD on 4/15/14.
//  Copyright (c) 2014 Trulia, Inc. All rights reserved.
//

#import "TLBLargeImageViewController.h"

@interface TLBLargeImageViewController () <UIAlertViewDelegate>

@property (retain, nonatomic) UIImageView *imageView;

@end

@implementation TLBLargeImageViewController

@synthesize imageView = _imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadOriginalImage:(NSString *)urlString {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame: CGRectMake(125, 125, 300, 300)];
    self.imageView = imgView;
    [self.view addSubview: _imageView];
    [imgView release];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString: urlString]];
        UIImage *img = [UIImage imageWithData: data];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (img != nil) {
                self.imageView.image = img;
            } else {
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle: @"Image Error"
                                                                     message: @"Image Loading Failed"
                                                                    delegate: self
                                                           cancelButtonTitle: @"OK"
                                                           otherButtonTitles: nil] autorelease];
                [alertView show];
            }
        });
    });
    
    dispatch_release(queue);
}

- (void)dealloc {
    
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // setup navigation bar
    self.view.backgroundColor = [UIColor whiteColor];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0, 0, 540, 44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle: @"Large Image Viewer"];
    [navBar pushNavigationItem: navItem animated: NO];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(doneButtonPressed:)];
    navItem.rightBarButtonItem = doneButton;
    [self.view addSubview: navBar];
    
    [navBar release];
    [doneButton release];
    [navItem release];
}

- (void)doneButtonPressed: (id)sender {
    [self.imageView removeFromSuperview];
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.imageView removeFromSuperview];
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
