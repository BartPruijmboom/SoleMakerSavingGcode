import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import controlP5.*;
ControlP5 cp5;
Textarea myTextarea;

import geomerative.*;
import AULib.*;
import megamu.mesh.*;

PrintWriter txt;

float PIXELPITCH =  .3514;
float DPMM = 1/PIXELPITCH;
float MMPP = 3*DPMM; // Millimeters between points on contour curve after loading
float prevX = 10;
float prevY = 10;
float prevMidX=0;
float prevMidY=0;
String printer = "Prusa";


void save() {
  SimpleDateFormat sdf = new SimpleDateFormat("HH-mm-ss_YYYYMMdd");
  Date now = new Date();
  // if detail is found save the GCode   
  String name = gcode_path +sdf.format(now);
  println("start saving GCODE as ", name);
  txt = createWriter(name + ".gcode");
  saveGCODE();
  txt.flush();
  txt.close();
  println("done");
  println(DPMM*width, DPMM*height);
}