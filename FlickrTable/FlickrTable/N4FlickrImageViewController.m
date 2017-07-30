//
//  N4FlickrImageViewController.m
//  FlickrTable
//
//  Created by Diligent Worker on 22.04.13.
//  Copyright (c) 2013 NumberFour AG. All rights reserved.
//

#import "N4FlickrImageViewController.h"
#import "N4FlickrImage.h"

@implementation N4FlickrImageViewController
{
    N4FlickrImage *_image;
}

#pragma mark - Initialization & Deallocation

- (id)initWithFlickrImage:(N4FlickrImage*)image
{
	if ((self = [super init])) {
        self.title = _image.title;
        _image = image;
	}
	return self;
}

-(void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_image.url]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        imageView.image = [UIImage imageWithData:data];
    }];
}

@end
