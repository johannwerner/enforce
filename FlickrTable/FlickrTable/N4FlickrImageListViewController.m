//
//  N4FlickrImageListViewController.m
//  FlickrTable
//
//  Created by Diligent Worker on 22.04.13.
//  Copyright (c) 2013 NumberFour AG. All rights reserved.
//

#import "N4FlickrImageListViewController.h"
#import "ImageCacheHelper.h"
#import "N4FlickrConstants.h"
#import "N4FlickerImageSource.h"
#import "N4FlickrImageCell.h"
#import "N4FlickrImageViewController.h"
#import "N4FlickrImage.h"

@interface N4FlickerImageCacheInfo : NSData
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) UIImage *image;

@end

@implementation N4FlickerImageCacheInfo
@end

@interface N4FlickrImageListViewController ()

@property (nonatomic, strong) N4FlickerImageSource *imageSource;

@property(strong, nonatomic) ImageCacheHelper *imageCacheHelper;

@end

@implementation N4FlickrImageListViewController

- (id)init
{
    self = [super init];
    if(self)
    {
        self.title = @"Recent Photos";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 75.0f;
    [self.tableView registerClass:[N4FlickrImageCell class]
        forCellReuseIdentifier:NSStringFromClass([N4FlickrImageCell class])];

    self.imageSource = [N4FlickerImageSource new];
    
    self.imageCacheHelper = [[ImageCacheHelper alloc] init];

    [self updatePhotos:nil];
}

- (void)updatePhotos:(id)sender
{
//#warning this indicator view is not visible :(
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    
    activityView.hidesWhenStopped = NO;
    activityView.color = [UIColor blueColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityView];

    [activityView startAnimating];
    [self.imageSource fetchRecentImagesWithCompletion:^{
        [self.tableView reloadData];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updatePhotos:)];
    }];
}

#pragma mark - UITableView DataSource/Delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView
	cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	N4FlickrImageCell *cell = [tableView dequeueReusableCellWithIdentifier:
        NSStringFromClass([N4FlickrImageCell class])];
    N4FlickrImage *flickrImage = [_imageSource imageAtIndex:indexPath.row];
    
    cell.title = flickrImage.title;
    
    cell.previewImage = nil;
    [self.imageCacheHelper fetchImageFromUrl:flickrImage.previewURL
                                   onDidLoad:^(UIImage *image) {
                                       if (image != nil) {
                                           cell.previewImage = image;
                                       } else {
                                           cell.previewImage = nil;
                                       }
                                   }];


	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.imageSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show the selected image in our image view controller

        N4FlickrImageViewController *ctrl = [[N4FlickrImageViewController alloc]
                                             initWithFlickrImage:[_imageSource imageAtIndex:indexPath.row]];
        [self.navigationController pushViewController:ctrl animated:YES];
}
@end
