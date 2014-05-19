//
//  TLBImageCell.m
//  TruliaCodeTestiPad
//
//  Created by JingD on 4/15/14.
//  Copyright (c) 2014 Trulia, Inc. All rights reserved.
//

#import "TLBImageCell.h"

@interface TLBImageCell ()

@property (retain, nonatomic) UIImageView *tbImageView;

@end

@implementation TLBImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.tbImageView = [[[UIImageView alloc] initWithFrame: CGRectMake(20, 2, 100, 100)] autorelease];
        
        [self.tbImageView removeFromSuperview];
        [self.contentView addSubview: self.tbImageView];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)configureCell:(TLBImage *)image {
    
    self.detailTextLabel.font = [UIFont systemFontOfSize: 15.0f];
    self.detailTextLabel.text = image.imageTitle;
    [self loadImageAsyncFromImage: image];
}

- (void)loadImageAsyncFromImage: (TLBImage *)image {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString: image.thumbnailImage]];
        UIImage *img = [UIImage imageWithData: data];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.tbImageView.image = img;
        });
    });
    
    dispatch_release(queue);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    self.tbImageView = nil;
    
    [super dealloc];
}

@end
