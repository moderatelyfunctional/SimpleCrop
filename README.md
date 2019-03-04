# Simple Vision

### Introduction

This app was created as a part of MIT's AT Hack 2019, by Team Charbel. Our objective was to make something that would aid Charbel in reading 7 segment displays. Our solution consists of an iOS app that takes a picture of a 7 segment display and processes it to yield a high contrast monochrome picture of the 7 segment display, which Charbel can then manually read.

Simple Vision was developed as an iOS mobile app using Swift 4.2.3. 

### Technical Details

##### Structure
`AppDelegate` calls `CropViewController` as the rootViewController. `CropViewController`'s view has two subviews: `previewView` and `photoButton`. `previewView` contains the live camera feed, and `photoButton` is a button that, when pressed, takes a photo at the camera's current orientation.

'PhotoViewController' has a view which contains three subviews: `photoContainer`, `slider`, and `takePhotoButton`. `photoContainer` displays the photo that was taken, `slider` is a slider that adjusts the adjusts the current `PhotoThreshold` (which is a parameter for the the `ThresholdFilter`, which affects how the photo is processed), and 'takePhotoButton' still is a button that takes a photo.

##### Image Processing
When a photo is taken, it is processed in the following way: first, we use the technique of global thresholding to come up with a raw monochrome picture, where the pixels that are too light are mapped to white and the pictures that are too dark are mapped to black. The intended target is a non backlit, 7 segment monochrome lcd display, which means that for an appropriate threshold value, the numbers will be black while the background is white. Then the image is inverted, so that the background is white and then the numbers are white. This gives us a nice image which Charbel can read.

##### Current Issues
Currently, the slider does not work because of some truly insane bugs which were not able to be fixed in the duration of this hackathon.
