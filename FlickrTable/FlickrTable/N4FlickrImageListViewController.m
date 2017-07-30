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
#import "FavouritesTableViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"RecentPhotos", nil);
    
    self.tableView.rowHeight = 75.0f;
    [self.tableView registerClass:[N4FlickrImageCell class]
        forCellReuseIdentifier:NSStringFromClass([N4FlickrImageCell class])];

    self.imageSource = [N4FlickerImageSource new];
    
    self.imageCacheHelper = [[ImageCacheHelper alloc] init];

    [self updatePhotos:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ViewFavourite", nil) style:UIBarButtonItemStylePlain target:self action:@selector(favourites)];
}

- (void)updatePhotos:(id)sender
{
// Indicator is now visible :)
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    
    activityView.hidesWhenStopped = NO;
    activityView.color = self.view.tintColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityView];

    [activityView startAnimating];
    N4FlickrImageListViewController * __weak weakSelf = self;
    [weakSelf.imageSource fetchRecentImagesWithCompletion:^{
        [weakSelf.tableView reloadData];
        
        weakSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:weakSelf action:@selector(updatePhotos:)];
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

#pragma mark - Selectors

- (void)favourites {
    FavouritesTableViewController *favouritesTableViewController = [[FavouritesTableViewController alloc] init];
    [self.navigationController pushViewController:favouritesTableViewController animated:YES];
}
@end
