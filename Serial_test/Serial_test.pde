//Serial test


import processing.serial.*;                                                                  //import serial library
Serial myPort;//Name the Serial object myPort.

float flt = 1700.123;

void setup ()
{
 String portName = Serial.list()[1];                                                       //Creates a string named portName the equals the serial port specfied in brackets.
 myPort = new Serial(this, portName, 9600);  
}

void draw ()
{
  
  int i = int(flt);
  String STR = str(i);
  String CR = "\r";
  myPort.write(STR);
  myPort.write(CR);
  
  //works//////don't mess////////////////
  //String STR = "1701/r";         //str(1700);
  //myPort.write(STR); 
 // print(STR);
}
