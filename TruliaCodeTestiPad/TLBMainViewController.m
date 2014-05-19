//
//  TLBMainViewController.m
//  TruliaCodeTestiPad
//
//  Copyright (c) 2013 Trulia, Inc. All rights reserved.
//

// Device version
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#import "TLBMainViewController.h"
#import "TLBImage.h"
#import "TLBImageCell.h"
#import "TLBLargeImageViewController.h"

@interface TLBMainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) TLBSearchRequestController *searchReqController;
@property (nonatomic, retain) UITableView *imageTableView;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@end

@implementation TLBMainViewController

@synthesize searchBar = _searchBar;
@synthesize searchReqController = _searchReqController;
@synthesize imageTableView = _imageTableView;
@synthesize imageArray = _imageArray;
@synthesize indicatorView = _indicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.searchReqController = [[[TLBSearchRequestController alloc] init] autorelease];
        self.searchReqController.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [_searchBar release];
    [_searchReqController release];
    [_imageTableView release];
    [_imageArray release];
    [_indicatorView release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    // setup image array
    self.imageArray = [[[NSMutableArray alloc] init] autorelease];
    
    // add search bar
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.view.bounds.size.width, 60.0f)] autorelease];
    } else {
        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 60.0f)] autorelease];
    }
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    // add table view
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.imageTableView = [[[UITableView alloc] initWithFrame: CGRectMake(0.0f, 80.0f, self.view.bounds.size.width, self.view.bounds.size.height-80) style: UITableViewStylePlain] autorelease];
    } else {
        self.imageTableView = [[[UITableView alloc] initWithFrame: CGRectMake(0.0f, 60.0f, self.view.bounds.size.width, self.view.bounds.size.height-80) style: UITableViewStylePlain] autorelease];
    }
    self.imageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageTableView.dataSource = self;
    self.imageTableView.delegate = self;
    [self.view addSubview: self.imageTableView];
    
    // add indicator view
    self.indicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    self.indicatorView.color = [UIColor blueColor];
    self.indicatorView.center = self.view.center;
    self.indicatorView.hidden = YES;
    [self.view addSubview: self.indicatorView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // TODO: Make sure everything looks correct on rotation.
	return YES;
}

#pragma mark -
#pragma mark UITableView data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_imageArray.count == 0) {
        return 0;
    }
    return [_imageArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // last row --> Load More Images button
    if (indexPath.row == [_imageArray count]) {
        
        static NSString *CellIdentifier = @"ButtonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *moreButton = [[[UIButton alloc] initWithFrame: CGRectMake(300, 35, 200, 40)] autorelease];
        [moreButton setBackgroundColor: [UIColor lightGrayColor]];
        [moreButton addTarget: self action: @selector(loadMoreImages:) forControlEvents: UIControlEventTouchUpInside];
        [moreButton setTitle: @"Load More Images" forState: UIControlStateNormal];
        [cell addSubview: moreButton];
        
        return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"ImageCell";
        TLBImageCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        
        if (cell == nil) {
            cell = [[[TLBImageCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: CellIdentifier] autorelease];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        TLBImage *image = [_imageArray objectAtIndex: indexPath.row];
        [cell configureCell: image];
        
        return cell;
    }

}

- (void)loadMoreImages: (id)sender {
    
    // animate indicator
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
    
    self.searchReqController.pageNumber++;
    [self.searchReqController searchRequestWithTerm:_searchBar.text];
}

#pragma mark -
#pragma mark UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 104.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // not last cell
    if (indexPath.row != _imageArray.count) {
        
        TLBLargeImageViewController *largeImageViewController = [[TLBLargeImageViewController alloc] init];
        
        largeImageViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        TLBImage *image = [self.imageArray objectAtIndex: indexPath.row];
        [largeImageViewController loadOriginalImage: image.image];
        [self presentViewController: largeImageViewController animated: YES completion: nil];
        
        [largeImageViewController release];
    }
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.imageArray removeAllObjects];
    [searchBar resignFirstResponder];
    self.searchReqController.pageNumber = 1;
    [self.searchReqController searchRequestWithTerm:searchBar.text];
    
    // animate indicator
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}

#pragma mark -
#pragma mark SearchRequestController Delegate Methods

-(void)searchRequestController:(id)srchRequestController gotResults:(NSArray *)results
{
    // TODO: Load the images and text in a display format you deem best.
    
    for (NSDictionary *dict in results) {
        TLBImage *image = [[TLBImage alloc] initWithJsonDictionary: dict];
        [self.imageArray addObject: image];
        [image release];
    }
    
    [self.imageTableView reloadData];
    
    [self.indicatorView startAnimating];
    self.indicatorView.hidden = YES;
}

@end
