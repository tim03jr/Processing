//Tracks a user's hand when they give the wave gesture.
//Then the x and z depth data is sent via serial to the Eddie board.
//Works in conjunction with Main_Code_V8.spin.


//TO DO: 
//Track a user's body not the hand. Can match the user id to hand id. (i.e. the one waving gets thier COM tracked.)
//On raised hand pause for a second and take a picture with webcam. Immediately send picture to printer.



import processing.serial.*;                                                                  //import serial library
Serial myPort;//Name the Serial object myPort.
import SimpleOpenNI.*;//Import the simpleopenNI library.
SimpleOpenNI kinect;//Declares and names our object/library kinect.

void setup() {
 size(640, 480);//The size that the kinect puts out. 
 String portName = Serial.list()[1]; 
 myPort = new Serial(this, portName, 9600);  
 kinect = new SimpleOpenNI(this);//Instantiate the SimpleOpenNI instance that was previously declared. Instantiating is confusing??????????????????????
 kinect.enableDepth();//Enable the depth sensor.
 kinect.enableHand();
 kinect.startGesture(SimpleOpenNI.GESTURE_WAVE);//options: wave, hand_Raise, click.
}

void draw() {
  kinect.update();                                       //Calls the update method of the kinect object. Probably refreshes the readings or takes new readings.
  PImage depth = kinect.depthImage();                    //A PImage variable is a place to store image data.
  image(depth, 0, 0);                                    //Our PImage that is our depth image is displayed here. 
}


void onCompletedGesture(SimpleOpenNI curContext, int gestureType, PVector pos)
{
  /*int handId = */kinect.startTrackingHand(pos);
  println("Hand!");
}

//SAME AS onNewHand exept loops continuously.
void onTrackedHand(SimpleOpenNI curContext, int handId, PVector pos){
  
                     //This is for the z data.
    int integer_posz = int(pos.z);//Convert float to integer.
    String STR_posz = str(integer_posz);//Convert integer to string.
    String CR = "\r";
    myPort.write("z"); 
    myPort.write(STR_posz);     
    myPort.write(CR);            
    println(STR_posz);
    
       
                    //This is for the x data.
    int integer_posx = int(pos.x);//Convert float to integer.
    String STR_posx = str(integer_posx);//Convert integer to string.
    myPort.write("x"); 
    myPort.write(STR_posx);    
    myPort.write(CR);            
   // println(STR_posx);                   
                                                           
}

void onLostHand(SimpleOpenNI curContext,int handId)
{
  println("Hand lost");
}



