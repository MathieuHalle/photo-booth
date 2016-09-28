// -------------------------------------------------------
// Photo Booth Project
// Author: BERTHA
// version: 1.0
// https://www.bertha.ca/
// -------------------------------------------------------

// -------------------------------------------------------
// user variables
// -------------------------------------------------------


// Define the number of images to take
int numberOfPhotoPerColToTake = 2;
int numberOfPhotoPerRowToTake = 2;

// Define our main stage background color
color bgColor = color(0);

// Where to display the result image on the thankyou page.
int bigScale = 3;  // Scale the image so it fits on the screen
int bigX = 0; // X position. If 0 is passed, the image will be centered on the screen.
int bigY = 0; // Y  If 0 is passed, the image will be centered on the screen.

// Where to save the images
String savePath = "images/";

// How long should the countdown should last
int countdownLenght = 4*1000; // In mills
// How long should the thank you screen be displayed
int thanksLenght = 8*1000; // In mills
// Delay between photos
int photoDelayLenght = 500; // In mills
// Sring to display instead if 0 when our countdown reach the end
String countdownEndString = ""; // Leave empty to display 0
// The color of the countdown text
color countdownColor = color(0);

// Define all our backgorund images and preload them
String[] stageBgImagesNames = { 
  "background/standby.png", 
  "background/countdown.png",
  "background/thanks.png"
};



// -------------------------------------------------------
// Init app variables
// -------------------------------------------------------

import processing.video.*;
import processing.opengl.*;

Capture cam;
PFont font;

PGraphics big;
int bigW; // This value will be overwritten at run time 
int bigH;

String currentState = "standBy";
PImage stageBgImage;
PImage[] stageBgImages = new PImage[stageBgImagesNames.length];

PImage[] tempPhotos = new PImage[numberOfPhotoPerColToTake*numberOfPhotoPerRowToTake];

boolean initCountdown = true;
boolean startedCountdown = false;

boolean initTakePhoto = true;
boolean initThanks = true;

Timer timer;

FadingText countdownDisplayText;
int countdownLastState;



// -------------------------------------------------------
// The setup
// -------------------------------------------------------
void setup() {
  // Set the stage size
  size(displayWidth, displayHeight, P2D);
  
  // Set the background color
  background(bgColor);
   
  // Preload our backgounrd Images
  for (int i=0; i < stageBgImagesNames.length; i++){
    String imageName = stageBgImagesNames[i];
    stageBgImages[i] = loadImage(imageName);
  }
  stageBgImage = stageBgImages[0];
  
  
  // Start our camera
  // Let get a list of available cameras
  String[] cameras = Capture.list();
 
  // Check if any cameras are available
  if (cameras.length == 0) {
    // If no, let the user know and exit the script
    println("There are no cameras available for capture.");
    exit();
  } else {
    // Cameras are available
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
      
    }
    
    // Grad the first camera available and use it.
    cam = new Capture(this, cameras[0]);
    cam.start();     
   
  }

  // Create our image to take  
  big = createGraphics(bigW, bigH, P2D);
  
  // This is optional but it will slow down the script to preserve some CPU  
  frameRate(15);
  smooth();


  // center our count down text
  textAlign(CENTER);
}



  

// -------------------------------------------------------
// The draw
// -------------------------------------------------------
void draw() {
  println(bigX);
  // Set the background color
  background(bgColor);
  
  // Display the proper bg image in the center of the display and make it fit
  stageBgImage.resize(displayWidth, 0);
  image(stageBgImage, 0, 0);
  
  // Cycle through various stage of the app.  
    if ( currentState == "standBy" ) {
      setupStandBy();
    } else if ( currentState == "countDown" ) {
      setupCountDown();
    } else if ( currentState == "takePhoto" ) {
      setupTakePhoto();
    } else if ( currentState == "thanks" ) {
      setupThanks();
    } 
}






// -------------------------------------------------------
// Application functions
// -------------------------------------------------------

// Put application in standby mode
void setupStandBy() {
  stageBgImage = stageBgImages[0];
}

// Start the countdown and display it
void setupCountDown() {
  // Check if we should init our timer ou 
  if ( initCountdown ) {
    stageBgImage = stageBgImages[1];
    timer = new Timer(countdownLenght);
    timer.start();
    initCountdown = false;
    
  } else {
    // Check if there is still time left to our counter
    if (timer.isFinished()) {
      // If our timer is done, let's go to the next step
      currentState = "takePhoto";
    } else {
      // Update our timer or display the current time
     
      // Check how much time is left
      int countdownNow = timer.timeLeft()/1000;
      
      // Check if the number displayed is in sync with the time left on our timer
      if ( countdownLastState != countdownNow ) {
        // If not, let's display the current time left on the timer
        countdownLastState = countdownNow;
        String countdownDisplayTextString = "" + countdownNow;
        // Optionaly, don't display a zero at the end but a string
        if (countdownNow == 0 && countdownEndString != "") {
          countdownDisplayTextString = countdownEndString;
        }
        // Start a new fading text
        countdownDisplayText = new FadingText(countdownDisplayTextString);
      } else {
        // Keep on displaying the curent timer
        countdownDisplayText.display();
      } 
    }
  }
}

// Take our photos and save them.
void setupTakePhoto() {
  
  if ( initTakePhoto ) {
    stageBgImage = stageBgImages[2];
    background(255);
    initTakePhoto = false;
  } else {
    
    // Check how if big has the proper size. If not, resize it.
    if ( big.width != cam.width || big.height != cam.height ) {
      bigW = cam.width * numberOfPhotoPerColToTake;
      bigH = cam.height * numberOfPhotoPerRowToTake;
      big = createGraphics(bigW, bigH, P2D); 
    }
    
    // begin to assemble the final image
    big.beginDraw();
    // Set the background white
    big.background(255);
    // Take our photos
    int tick = 0;
    // Loop trought the rows
    for( int e = 0; e < numberOfPhotoPerRowToTake; e++ ) {
      // Loop trought the cols
      for( int i = 0; i < numberOfPhotoPerColToTake; i++ ) {
        // Grab the current image from the camera
        tempPhotos[tick] = cam.get(0,0,cam.width, cam.height);
        // Place it on the big image et that proper position
        big.image(tempPhotos[tick], cam.width*i, cam.height*e);
        tick ++;
        // Wait before taking the next picture
        delay(photoDelayLenght);
      }
    }
    // End our image draw
    big.endDraw();
    
    // Save our image
    String tt = getTime();
    big.save( savePath + "capture-"+ tt +".jpg");
    
    // Advance to the next step
    currentState = "thanks"; 
  }
}

// Go to the thank you page and display the resulting image  to the user.
void setupThanks() {
  // Check if we should init the thank you page, just wait for it to finish
  if ( initThanks ) {
    // Start a new timer
    timer = new Timer(thanksLenght);
    timer.start();
    initThanks = false;
  } else {
    // Timer is running, let's display our image to the user
    
    // check where to place the image
    int bigFinalX = bigX;
    int bigFinalY = bigY;
    // if no value defined, let's center our image on the stage
    if (bigX == 0) {
      bigFinalX = (displayWidth/2) - (bigW/bigScale/2);
    }
    if (bigY == 0) {
      bigFinalY = (displayHeight/2) - (bigH/bigScale/2);
    }
    image(big, bigFinalX, bigFinalY, bigW/bigScale, bigH/bigScale);
    // check if the timer is finished
    if (timer.isFinished()) {
      stageBgImage = stageBgImages[0];
      resetStandBy();
    } 
  }
}






// -------------------------------------------------------
// Event handlers
// -------------------------------------------------------

// Read from the webcam when it's available
void captureEvent(Capture c) {
  c.read();
}

void keyReleased() {
  startCountDown();
}

void mousePressed() {
  startCountDown();
}






// -------------------------------------------------------
// Helper functions
// -------------------------------------------------------

// Start the countdown
void startCountDown() {
  if ( currentState == "standBy" ) {
    currentState = "countDown";
  }
}

// This function will reset various value to default setting and reset the app
void resetStandBy() {
  currentState = "standBy";
  initCountdown = true;
  initTakePhoto = true;
  initThanks = true;
}

// Funtiont that return the current time as a yyyymmdd-hhmmss
String getTime() {
  String s = nf( second(), 2 );  // Values from 0 - 59
  String i = nf( minute(), 2 );  // Values from 0 - 59
  String h = nf( hour(), 2 );    // Values from 0 - 23
  String d = nf( day(), 2 );    // Values from 1 - 31
  String m = nf( month(), 2 );  // Values from 1 - 12
  String y = nf( year(), 4 );   // 2003, 2004, 2005, etc.
  
  return y + m + d + "-" + h + i + s;
}





// -------------------------------------------------------
// Helper classes
// -------------------------------------------------------

class FadingText {
  String txt;
  float alpha, size;
  float r, g, b, x, y;

  FadingText (String _txt) {
    txt = _txt;
    alpha = 255;
    size = 300;
  }

  void display() {
    textSize(size);
    fill(countdownColor, alpha);
    text(txt, width/2, height/2+150);
    alpha-=10;// fading speed
    if ( size > 10 ) {
      size-=10;
    }
    
  }

  boolean isDone() {
    return alpha < 0;
  }
}




class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis(); 
  }
  
  int timeLeft() {
   return totalTime - (millis()- savedTime);
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
   }
   
 }
 
 