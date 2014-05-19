//
//  TLBImage.m
//  TruliaCodeTestiPad
//
//  Created by JingD on 4/15/14.
//  Copyright (c) 2014 Trulia, Inc. All rights reserved.
//

#import "TLBImage.h"

@implementation TLBImage

- (id)initWithJsonDictionary:(NSDictionary *)json {
    
    if (self = [super init]) {
        
        self.thumbnailWidth = json[@"tbWidth"];
        self.thumbnailHeight = json[@"tbHeight"];
        self.thumbnailImage = json[@"tbUrl"];
        
        self.imageWidth = json[@"width"];
        self.imageHeight = json[@"height"];
        self.image = json[@"url"];
        
        self.imageTitle = json[@"titleNoFormatting"];
    }
    
    return self;
}

- (void)dealloc {
    
    [self.thumbnailHeight release];
    [self.thumbnailWidth release];
    [self.thumbnailImage release];
    [self.imageWidth release];
    [self.imageHeight release];
    [self.image release];
    [self.cachedID release];
    
    [super dealloc];
}

@end
