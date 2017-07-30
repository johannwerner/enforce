//
//  N4FlickrImageViewController.m
//  FlickrTable
//
//  Created by Diligent Worker on 22.04.13.
//  Copyright (c) 2013 NumberFour AG. All rights reserved.
//

#import "N4FlickrImageViewController.h"
#import "N4FlickrImage.h"
#import "API.h"
#import "SaveFavouriteOntoDiskHelper.h"

@interface N4FlickrImageViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) N4FlickrImage *image;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *fullScreenImageView;

@end

@implementation N4FlickrImageViewController

#pragma mark - Initialization & Deallocation

- (id)initWithFlickrImage:(N4FlickrImage*)image
{
	if ((self = [super init])) {
        self.title = _image.title;
        _image = image;
	}
	return self;
}

-(void)loadView { //Fixed wierd animation when going to this view
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"AddFavourite", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addFavourite)];
    
    self.title = self.image.title; //Long title maybe we can 
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    
    
    [self.view addSubview:self.scrollView];
    
    self.scrollView.delegate = self;
    
    self.fullScreenImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.fullScreenImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.fullScreenImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.fullScreenImageView];
    
    N4FlickrImageViewController* __weak weakSelf = self;
    [API fetchImageFromUrl:self.image.url onDidLoad:^(UIImage *image) {
        
        weakSelf.fullScreenImageView.image = image;
        
        CGFloat scrollViewWidth = weakSelf.view.frame.size.width;
        CGFloat scrollViewHeight = weakSelf.view.frame.size.height;
        
        CGFloat widthRatio = scrollViewWidth / image.size.width;
        CGFloat heightRatio = scrollViewHeight / image.size.height;
        weakSelf.scrollView.minimumZoomScale = MIN(heightRatio, widthRatio);
        weakSelf.scrollView.maximumZoomScale =
        MAX(weakSelf.scrollView.minimumZoomScale, scrollViewWidth / 1248) * 4;
        weakSelf.scrollView.zoomScale = weakSelf.scrollView.maximumZoomScale/2;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.fullScreenImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat scaledWidth = self.scrollView.zoomScale * self.fullScreenImageView.image.size.width;
    CGFloat scaledHeight = self.scrollView.zoomScale * self.fullScreenImageView.image.size.height;
    
    CGFloat horizontalPadding = MAX((self.view.frame.size.width - scaledWidth) / 2, 0);
    CGFloat verticalPadding = MAX((self.view.frame.size.height - scaledHeight) / 2, 0);
    
    self.scrollView.contentInset =
    UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding);
}

-(void)addFavourite {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"AppName", nil)
                                                                              message: NSLocalizedString(@"AddCommentOnFavourite", nil)
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"CommentPlaceHolderKey", nil);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"CancelKey" , nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    N4FlickrImageViewController* __weak weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OKKey", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * commentTextField = textfields[0];
        weakSelf.image.comment = commentTextField.text;
        
        
        [SaveFavouriteOntoDiskHelper addFavourtiteImage:weakSelf.image];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
