
//This code was downloaded from the dot matrix printer instructables.
//I wonder if the pixel array can be sent all at once rather than one pixel at a time?





import processing.serial.*;                             //Loads a library into a processing sketch(the serial library). The * is used to load all related classes. 
Serial myPort;                                          //Create object from Serial class. I Think we are naming this serial port, myport.
PImage IMG;                                             //Create a PImage named IMG





void setup() {
  size(60,92);                                        //Put here the size of your image
  String portName = Serial.list()[1];                   //Declare a string named portName. The Serial.list gets all of the available serial ports. I think the [0] causes the number of the first available serial port to be stored in the portName string.
  myPort = new Serial(this, portName, 9600);            //Opens the Serial Port that was saved into the string "portname." Syntax(The sketch you are referencing, the port to open, the baudrate).
  IMG = loadImage("arduino.bmp");                       //Sets our PImage(IMG) to the image that we want to load. Image must be in the data directory. 
  image(IMG, 0, 0);                                     //Image "draws" the image of choice to the display window. Syntax: image(Which image, x, y). x and y are the location of the upper right corner of the image.
}




void draw() {
  IMG.loadPixels();                                    //I think that this loads all of the pixels from the IMG image. Not sure where it loads them to. Seems to be some mechanical necessity.
  for (int y = 0; y < height; y++) {                   //Running through all of the pixels one by one
    for (int x = 0; x < width; x++) {                 
      int loc = x + y*width;                           //Loc is the location of an individual pixel. It changes each time through the loop. 2-d arrays start with 0.
      if (IMG.pixels[loc]>color(128)) {                //Checks each pixel. 128 is the treshold for determining whether a pixel is white or black.
        myPort.write(0);                               //If a pixel is greater than 128, send a '0' for white.
        print(0);
        delay(500);                                     //Give time for the data to transmit.
      }
      else {
        myPort.write(1);                               //if a pixel is less than 128, send a '1' for black.  
        print(1);
        delay(500);
      }
    }
    
    myPort.write('L');                                 //send a "L" to indicate a new line.
    print('L');
  }
  //Should probably send something saying we're done so that the steppers can go to zero.
  noLoop();                                           //Stops the code from looping again and trying to print over what was just printed.
}

