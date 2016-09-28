# Photo booth script for Processing 3.



This script will turn any computer that has a webcam attached to it into a photo booth, for free !

Built on the open source [Processing 3](https://processing.org/download/?processing) language, it can be run on Mac, Window and Linux.

This is my first [Processing 3](https://processing.org/download/?processing) app.


## How it works
First, you must download and install [Processing 3](https://processing.org/download/?processing) on your computer.
Then, you must [download](https://github.com/icibertha/photo-booth/archive/master.zip) and run this script. **The script has 3 stages:**

### Stand by
At first, the app waits for a user input. Simply press any key on the keyboard or click anywhere with the mouse to get started. You can also [make or buy](http://help.sparkbooth.com/kb/building-your-own-photo-booth/usb-button-keyboard-replacements) a button.


### Countdown
The app will now display a countdown so the user can get ready for the picture.

### Thank you
After the picture is taken, it is displayed to the user on the thanks you page.

The images are named with a timestamp and saved in the `photoBooth/images` folder 


## Configuration

You can change some options at the beginning of the script, especially the number of pictures to take. To do so, you can edit 2 values at the beginning of the script: `numberOfPhotoPerColToTake`, `numberOfPhotoPerRowToTake`. By default, they are both set to 2, which means that the app will take 4 pictures and stitch them to make 1 single image. if you only want to take 1 picture, set `numberOfPhotoPerColToTake` and `numberOfPhotoPerRowToTake` to 1.

You can also edit the background images to add your own design. The images are located in the `photoBooth/data/background` folder.

