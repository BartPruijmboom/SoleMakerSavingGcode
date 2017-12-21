void startGcode() {// currently for an Ultimaker 2.  Cut and Paste from Cura generated gCode
  if (printer == "UltiMaker") {
    txt.println(";FLAVOR:UltiGCode");
    txt.println("; TIME:400");
    txt.println(";MATERIAL:160");
    txt.println("; MATERIAL2: 0");
    txt.println(";NOZZLE_DIAMETER: " +nozzleDiameter/DPMM);
    //  txt.println(";NOZZLE_DIAMETER2: 0.800000");
    //txt.println(";Layer count: " + nf(layersTotal));
    txt.println(";LAYER: 0");
    txt.println("G0 F9000 X10 Y110");
    txt.println("G0  F"+nf(speed)); //Start Layer
  } else if (printer == "Prusa") {
    txt.println(";FLAVOR:RepRap");
    //txt.println(";LAYERS:" + layersTotal);
    txt.println(";Layer height:" + layerHeight);
    txt.println(";NOZZLE DIAMETER:" + nozzleDiameter/DPMM);
    txt.println("M104 S240");
    txt.println("M109 S240");
    txt.println("G21 ;metric values");
    txt.println("G90 ;absolute positioning");
    txt.println("M82 ;set extruder to absolute mode");
    txt.println("M107 ;start with the fan off");
    txt.println("G28 X0 Y0 ;move X/Y to min endstops");
    txt.println("G28 Z0 ;move Z to min endstops");
    txt.println("G1 Z15.0 F9000 ;move the platform down 15mm");
    txt.println("G92 E0 ;zero the extruded length");
    txt.println("G1 F200 E30 ;extrude 3mm of feed stock");
    txt.println("G92 E0 ;zero the extruded length again");
    txt.println("G1 F9000");
    txt.println("M117 Printing...");
    txt.println("M107");
    txt.println("G1 F"+speed);
  } else {
  }
}

void endGcode() {// currently for an Ultimaker 2 Extended.  Cut and Paste from Cura generated gCode
  if (printer == "UltiMaker") {
    txt.println("M107");
    txt.println("G10");
    txt.println("G0 F9000 X110.000 Y126.900 Z150");
    txt.println("M25 ;Stop reading from this point on.");
    txt.println(";GCODE GENERATED WITH SHOEMAKER(c) 2017, MADE BY BART PRUIJMBOOM AT TU/E, BADSED ON SOLEMAKER (c) 2015 (BY L. FEIJS, T.R. NACHTIGALL, B.A.PRUIJMBOOM)");
    txt.println(";CURA_PROFILE_STRING:eNrtWt1v2zYQfxWC/RF8bLHGk2S7aWvoYe2SvqRDgXhYmxeBlmiLi0QKJBXHCfy/746iFNlRunQN1o/JDw70093xePe7j6LO6YapOGN8lZnIHwXemuZ5bDKeXAimNUATTzGjaGK4FDETdJGzaK4q5mmZ8zTOrYGuwnNvycFGyoTmZhOFvlcqLkysS8bSaNo8GlaUTFFTKRaFQQ8aRj3guA+c9IHTFlywdOe0I9/TVVlKZaK5rJKMixVZVDxPy5wa5uH3UqoipmnGNNw6+l0K1qjEaUXzmF0ZVdl3r6XJvDUvWWzkmqnohOaadYD4UuZVwaJg6kl5zWKdcZanTgwCRQsGLqYc/hpQD0cvpndhDMUdcNwHTvrAaRdc5nIdBb4/8j0hr69zcIlfs/1E18maoFQHpYWshIkmo2kXtRFxr4Lnu+8KLmJ4uGR5FOy+SWSxgMhHv+b5ngIvdiIMPoRdiUyWiHkLaYwsdqg39iwd/XjNU5PFS9CQCi/rycVfLAEOcnEBwZCXTOW0tJ4j66de7aO7djDt2K8JXr8ALnNh2V0/o5gtA6oY7WBcaGb8feCqAyRS5jY4rn44UAQST5sSS12NXXCgXM4Fg3jZ+DpoRctojKfbpyZoORMrkzn/0diyAl9ddU8d5u7od57igl5ZpHVrCSiUC/DWgRmjUOx8aRx16+o3kIvucx2zW3bnsQs18h8KkFs+QkVCgbG4jmVjwNWX2ZQsOoUb6xaiYgVN53lbtrG1XLs3bcGrDRBeGyoSZPNRi193YZQvuaI5ct4dzIsSqqCQqWtsC3CzG3PIuqJLiDJVKy5sHO2zFdElTZDG4wZdUM32SHmLo4rlJlSDk4cOxRQwdVcpPNp/e6tqSxVfUq6ABzF0bMupDoYWwhrQldNHouloD+07s9XYOXHJr6D0lOLAzrgSth3gqIB0xbQO3KdEFi0pujIQElkyES+40X0C0AVwjFxCnA03tlU7sTKvIBmQIeDQKmrqO2EYr/gqOgz2oA1APwENlBmtEkz17CznCUsJNa/ITUo3W/w2DP5gMW4PZq+p5gmBujVwqn5FTjGApC4mUMk7k3NL/oSLgszN7vjckhNgKsDdiQim3+NcIngOvHOTqz70xLVpAqFJa8W6bdf9dVt0oHV99qqjlUhtulr4DFbfBS99cnbTOw63ZPaHgGZs9Y0kNE3JRlaKyLUgIEs6sgQpgeb8l625h5q6Y+ZtGBD3mUFbUBDsS5pXTB+8BW+bN3QBnaUyjJQSggeUgmQcvHsRtgKQIGKHRQrZwUMbBSzoA3D1qJXE7JM1NxkxGSPQ/YhcLsGPF+SDTz766Ae0K/Lhl49oCNogYSLV0OO0FTr3nbModH5XJCDnATQHcnLTnSZbp4BHNqsFSTEiwbQo4K4hOW6ve/uZXTMlrZK7XErq7o7nnIS+T47HexpOkIyLAi5GsIUTcC25+PxDCF1RLuxRu5cB7laG2Mzj2lQAyemKESnI6ZvfiE4UYwKCHhyR905mNBp5EKOm6o5FSt6+camZkLMerzp3wXqDolQ2Ue+CiX+vgpVLLWFvVcgTvkQGkgyuQLh5CpEIyAM+M8UgVdB3dmgH4Tg+hJCMff8flO2yUrOsKU1KoMmRevIRHKQYP5Sot7BnyCc4lcGYIFoWDFNoOaMgxlA0ll8/+6Mp+DAlHw5DoCx+9bPtnFSlO5JCxBuPWm/YJRNQIWj2lv6fvNR9pfEMvLWO4oZAuCYSCOJ8X9MN1OrkfqPasBK6gq4L8eX9PvT3gRn0IAl3wvEAdFttPVvj4dDiH6HFT768xdeTYh70WQr/lSn/686db32azO/pbrOzNa5PeApqhtASmg77JRMo8PsnUOA/6giyZx3e9P+Tc3sw9x906SVX2nxP136kyRveM3rn/mdOX9QJhok9TOzHn9jjYWIPE/v/ObHDBw2vsfqhJvawpgxryt6aMv6aawrqhMNqM6w2j7/aTIbV5ptabcLHW22GLek/25LGD5qdE3D6B1oYhtVwWA2H1VCkk+9tNUSd8bBODuvk466T7gct3V8xtODtf7HWv9fZEbJIR0IxmLEJGyX6MvIgCXWbOXa8bBfWuvksmFlDZdpLJ5VSNsQNhTEBNtGAtOgzss5Aoa10u0wUVW54mbftQunRwWyeQVDxNAwurDeW5ZZFaHT+RDz1ICbmW/KPLrEAG/f+BnWV/Wo=");
  } else if (printer == "Prusa") {
    txt.println("M107");
    txt.println("M104 S0 ;extruder heater off");
    txt.println("M140 S0 ;heated bed heater off (if you have it)");
    txt.println("G91 ;relative positioning");
    txt.println("G1 E-1 F300  ;retract the filament a bit before lifting the nozzle, to release some of the pressure");
    txt.println("G1 Z+5 E-5 X-20 Y-20 F9000 ;move Z up a bit and retract filament even more");
    txt.println("G28 X0 Y0 ;move X/Y to min endstops, so the head is out of the way");
    txt.println("M84 ;steppers off");
    txt.println("G90 ;absolute positioning");
    txt.println("M104 S0");
    txt.println(";End of Gcode");
    txt.println(";GCODE GENERATED WITH SHOEMAKER(c) 2017, MADE BY BART PRUIJMBOOM AT TU/E, BADSED ON SOLEMAKER (c) 2015 (BY L. FEIJS, T.R. NACHTIGALL, B.A.PRUIJMBOOM)");
  } else {
  }
}

void setMachineSettings() {
  if (printer=="Ultimaker") {
    xSizeBuildplate =int(223 * DPMM);
    ySizeBuildplate =int(223 * DPMM);
    xSizePrintArea = int(210*DPMM);
    ySizePrintArea = int(210*DPMM);
    ext = 0; //extrusion step   
    speed = 1500;
    layerHeight = 0.25;
    currentLayer = 0;
    extrusionCoefficient1 = .3  ;
    extrusionCoefficient = extrusionCoefficient1;
    retraction = 0;
    nozzleDiameter =0.8*DPMM;
    slicedistance1 = 1.6 * DPMM;//Nozzel Diameter x 2
    layersProfileAtOnce = 5;
  } else if (printer=="Prusa") {
    xSizeBuildplate =int( 210 * DPMM);
    ySizeBuildplate =int( 340 * DPMM);
    xSizePrintArea = int(200*DPMM);
    ySizePrintArea = int(330*DPMM);
    ext = 0; //extrusion step   
    speed = 1500;
    layerHeight = 0.25;
    currentLayer = 0;
    extrusionCoefficient1 = .01  ;
    extrusionCoefficient = extrusionCoefficient1;
    retraction = 0;
    nozzleDiameter =0.4*DPMM;
    slicedistance1 = .8 * DPMM;//Nozzel Diameter x 2
    layersProfileAtOnce = 10;
  }
}

//Printer settings
float ext = 0; //extrusion step   
float speed = 1500;
float speed1 = 1500;
float layerHeight = 0.25;
float currentLayer = 0;
float extrusionCoefficient1 = .02  ;
float extrusionCoefficient = extrusionCoefficient1;
float retraction = 0;
float nozzleDiameter =0.4*DPMM;
float slicedistance1 = .4 * DPMM;//Nozzel Diameter x 4
float slicedistance;
float[] fitShoe = new float[3];
int layersProfileAtOnce = 5;

int xSizeBuildplate =int( 220 * DPMM);
int ySizeBuildplate =int( 380 * DPMM);
int xSizePrintArea = int(200*DPMM);
int ySizePrintArea = int(330*DPMM);