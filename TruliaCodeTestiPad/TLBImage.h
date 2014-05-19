//
//  TLBImage.h
//  TruliaCodeTestiPad
//
//  Created by JingD on 4/15/14.
//  Copyright (c) 2014 Trulia, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLBImage : NSObject

@property (retain, nonatomic) NSNumber *thumbnailWidth;
@property (retain, nonatomic) NSNumber *thumbnailHeight;
@property (retain, nonatomic) NSString *thumbnailImage;

@property (retain, nonatomic) NSNumber *imageWidth;
@property (retain, nonatomic) NSNumber *imageHeight;
@property (retain, nonatomic) NSString *image;

@property (retain, nonatomic) NSString *imageTitle;

@property (retain, nonatomic) NSString *cachedID;

- (id)initWithJsonDictionary: (NSDictionary *)json;

@end
