iOSChallenge
============

The given app fetches the recent images added to flickr.com and displays their previews in a table view controller. The user can
select an image and the image is fetched from flickr.com and presented in a second view controller.

Software quality is extremely important to us, and this starts with code quality.
Though this app is no production code, we want you to use it to demonstrate us how you think about code quality. We left some open issues,
minor bugs and some awful architectural decisions in the source. 

Feel free to fix anything you discover! And if you see something that is wrong or really a bad idea, please show us a better way to do it. :-)

*Known Issues*
- There is a delay when you select an image before it is displayed, the app is not responsive until the image is shown
- I added an activity indicator view in updatePhotos: that should be visible while the list of recent images is fetched from server, but it is not visible?
- Preview images in list are not always shown, sometimes previews are shown and are later replaced by another preview?

*Missing Features*
- Let the user mark images as favorites, which will be stored locally together with a comment. Have a separate table view controller that shows the users favorites
- Prefetch the preview images so they appear instantly when the user starts scrolling
- Add zoom gesture to N4FlickrImageViewController
