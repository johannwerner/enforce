//
//  N4FlickrImageListViewController.m
//  FlickrTable
//
//  Created by Diligent Worker on 22.04.13.
//  Copyright (c) 2013 NumberFour AG. All rights reserved.
//

#import "N4FlickrImageListViewController.h"

#import "N4ImageCacheHelper.h"
#import "N4FlickrConstants.h"
#import "N4FlickerImageSource.h"
#import "N4FlickrImageCell.h"
#import "N4FlickrImageViewController.h"
#import "N4FlickrImage.h"
#import "N4FavouritesTableViewController.h"

@interface N4FlickrImageListViewController ()

@property (nonatomic, strong) N4FlickerImageSource *imageSource;

@property(strong, nonatomic) N4ImageCacheHelper *imageCacheHelper;

@end

@implementation N4FlickrImageListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"RecentPhotos", nil);
    
    self.tableView.rowHeight = N4FlickrImageCellHeightConstant;
    [self.tableView registerClass:[N4FlickrImageCell class]
        forCellReuseIdentifier:NSStringFromClass([N4FlickrImageCell class])];

    self.imageSource = [N4FlickerImageSource new];
    
    self.imageCacheHelper = [[N4ImageCacheHelper alloc] init];

    [self updatePhotos:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ViewFavourite", nil) style:UIBarButtonItemStylePlain target:self action:@selector(favourites)]; //Should consider icon here
}

- (void)updatePhotos:(id)sender
{
// Indicator is now visible :)
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    
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
    N4FlickrImage *flickrImage = [_imageSource imageAtIndex:(NSUInteger) indexPath.row];
    
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

        N4FlickrImageViewController *flickrImageViewController = [[N4FlickrImageViewController alloc]
                                             initWithFlickrImage:[_imageSource imageAtIndex:(NSUInteger) indexPath.row]];
        [self.navigationController pushViewController:flickrImageViewController animated:YES];
}

#pragma mark - Selectors

- (void)favourites {
    N4FavouritesTableViewController *favouritesTableViewController = [[N4FavouritesTableViewController alloc] init];
    [self.navigationController pushViewController:favouritesTableViewController animated:YES];
}

@end
