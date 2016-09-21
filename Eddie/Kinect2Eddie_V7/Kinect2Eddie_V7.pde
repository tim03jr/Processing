//This code tracks a user's hand. The user comes into the camera's view, makes a wave gesture, and the onCompletedGesture function loops constantly updating the position vector.


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
 kinect.enableUser();//This must be enabled to use onNewUser function.
 kinect.enableHand();
 kinect.setMirror(true);//This causes the image produces by the kinect to be mirrored.
 kinect.startGesture(SimpleOpenNI.GESTURE_WAVE);//options: wave, hand_Raise, click.

}

void draw() {
  kinect.update();                                       //Calls the update method of the kinect object. Probably refreshes the readings or takes new readings.
  PImage depth = kinect.depthImage();                    //A PImage variable is a place to store image data.
  image(depth, 0, 0);                                    //Our PImage that is our depth image is displayed here.
 
  IntVector userList = new IntVector();                  //Make a vector of ints to store the list of users. Special type of variable provided by OpenNI specifically for storing user ID's.
  kinect.getUsers(userList);                             //Write the list of detected users into our vector. 



}



//ONNEWUSER IS FIRST
//ONCOPLETEDGESTURE IS SECOND.
//ONNEWHAND IS THIRD.

// user-tracking callbacks!

void onNewUser(SimpleOpenNI curContext, int userId) 
{
  println("New User");  
}

void onCompletedGesture(SimpleOpenNI curContext, int gestureType, PVector pos)
{
  /*int handId = */kinect.startTrackingHand(pos);
  println("Hand!");
}

//void onNewHand(SimpleOpenNI curContext,int handId,PVector pos)//These parameters are where onNewHand stores data. loops only one time.
//{
//  println("OMG");
//  println(pos.z);
//}

//SAME AS onNewHand exept that it loops continuously.
void onTrackedHand(SimpleOpenNI curContext, int handId, PVector pos){
 println(pos.z); 
 println(handId);
}

void onLostHand(SimpleOpenNI curContext,int handId)
{
  println("Hand lost");
  //handPathList.remove(handId);
}



