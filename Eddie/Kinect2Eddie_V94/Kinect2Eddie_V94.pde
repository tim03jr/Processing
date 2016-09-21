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
 size(displayWidth, displayHeight);
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

  int time = millis();
  
  if (wave_time != 0)//WAVE_TIME IS SET IN THE WAVE FUNCTION.
  {
    int delay = time - wave_time;//DELAY = CURRENT CLOCK NUMBER MINUS THE CLOCK NUMBER WHEN WAVE WAS INITIATED.
 
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


void onCompletedGesture(SimpleOpenNI curContext, int gestureType, PVector pos)//WAVE gestureType = 0. HAND_RAISE gestureType = 2. HANDRAISE IS TOO SENSITIVE
{
 // if (wave_check == 0)
 // {
    println("Hand is being tracked");
    kinect.startTrackingHand(pos);
 //   wave_check = 1;
 // }
//  if (wave_check == 1)
//  {
   println("Picture is being taken");
   //When hand is waved, send notification to Eddie.
   myPort.write("p");  
   wave_time = millis(); 
//  } 
}

void onTrackedHand(SimpleOpenNI curContext, int handId, PVector pos)
{  
 //println(handId);
       if (pos.x > 500 )
      {
        String CR = "\r";
        myPort.write("x"); 
        myPort.write(0);    
        myPort.write(CR);
      }
      if (pos.x < -500 )
      {
        String CR = "\r";
        myPort.write("x"); 
        myPort.write(0);    
        myPort.write(CR);
      }
      if (pos.x < 500)
      {      
        if (pos.x > -500)
        {
 
         //This is for the x-data.
        int intgr_posx = int(pos.x);//Convert float to integer.
        String STR_posx = str(intgr_posx);//Convert integer to string.
        String CR = "\r";
        myPort.write("x"); 
        myPort.write(STR_posx);    
        myPort.write(CR);            
        println(STR_posx); 
              
        //print z-value to serial.
        int intgr_posz = int(pos.z);//Convert float to integer.
        String STR_posz = str(intgr_posz);//Convert integer to string.
        myPort.write("z"); 
        myPort.write(STR_posz);     
        myPort.write(CR);
        //println(STR_comz);
        }
      }
}


void onLostHand(SimpleOpenNI curContext,int handId)
{
  println("Hand lost");

        String CR = "\r";
        myPort.write("x"); 
        myPort.write(0);    
        myPort.write(CR); 
        myPort.write("z"); 
        myPort.write(0);     
        myPort.write(CR);
}


void onNewUser(SimpleOpenNI curContext, int userId) 
{
  println("New User");  
}





