//Displays RGB camera data to new window.
//Tracks a user's COM.
//Takes a picture when hand is waved.



import processing.serial.*;
import SimpleOpenNI.*;//Import the simpleopenNI library.

Serial myPort;//Name the Serial object myPort.
SimpleOpenNI kinect;//Declares and names our object/library kinect.

PVector com = new PVector(); 
int Num = 0;
int wave_time = 0;
int wave_check = 0;

void setup() {
 size(displayWidth, displayHeight);//Might want to figure out how to make fullscreen.
 String portName = Serial.list()[1]; /////////////////////////////////////////////////////////////////////////////ALWAYS CHECK THIS IF NOT WORKING/////////////////////////////////////////////////////////////////////////////////////
 myPort = new Serial(this, portName, 9600);  
 kinect = new SimpleOpenNI(this);//Instantiate the SimpleOpenNI instance that was previously declared. Instantiating is confusing??????????????????????
 kinect.enableDepth();//Enable the depth sensor.
 kinect.enableHand();
 kinect.enableUser(); 
 kinect.enableRGB();
 kinect.startGesture(SimpleOpenNI.GESTURE_WAVE);//options: wave, hand_Raise, click.
}

void draw() {
  kinect.update();                                       //Calls the update method of the kinect object. Probably refreshes the readings or takes new readings.
  PImage depth = kinect.depthImage();                    //A PImage variable is a place to store image data.
  image(kinect.rgbImage(),displayWidth/2 - 320, displayHeight/2 - 240);
  //image(depth, 0, 0);                                 //Our PImage that is our depth image is displayed here. 
  int[] userList = kinect.getUsers();
  int time = millis();
  
  if (userList.length != 0)
  {
    int i = userList.length;    
    kinect.getCoM(userList[i-1],com);
    
    if (com.z != 0)
    {
     // println(com.z);
      
      //This is for the x-data.
      int intgr_comx = int(com.x);//Convert float to integer.
      String STR_comx = str(intgr_comx);//Convert integer to string.
      String CR = "\r";
      myPort.write("x"); 
      myPort.write(STR_comx);    
      myPort.write(CR);            
      // println(STR_posx); 
            
      //print z-value to serial.
      int intgr_comz = int(com.z);//Convert float to integer.
      String STR_comz = str(intgr_comz);//Convert integer to string.
      myPort.write("z"); 
      myPort.write(STR_comz);     
      myPort.write(CR); 
    }
    
    if (com.z == 0)
    {
      //Print "l" to serial.
      myPort.write("l");
    }
    
  }
  
  if (wave_time != 0)
  {
    int delay = time - wave_time;
 
    if (delay > 3000)
    {
      // take a picture.
      println("Picture");
      println(delay);
      Num = Num + 1;//Allows for picture files to have different names.
      save("Pict" + Num + ".jpg");  
      wave_time = 0;  
    } 
  }
}

void onLostUser(SimpleOpenNI curContext, int userId)//Takes about 30 seconds to print this.
{
  println("Lost User");
  myPort.write("l");
}

void onCompletedGesture(SimpleOpenNI curContext, int gestureType, PVector pos)//WAVE gestureType = 0. HAND_RAISE gestureType = 2.
{
  wave_check = 1;
  println("Hand!");
  //When hand is waved, send notification to Eddie.
  myPort.write("p");  
  wave_time = millis();
}


//void delay(int delay)
//{
//  int time = millis();
//  while(millis() - time <= delay);
//}


