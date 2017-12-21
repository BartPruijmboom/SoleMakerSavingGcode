float angle;
float baseFreq;
float baseAmp;
float highFreq;
float highAmp;
float sDist1;
float sDist2;
float zoom;
int change = 0;
float[] viewPort = new float[3];
float[][] contour = new float[0][];
float[][] infill = new float[0][];

int mouseState =0;
float mousePrevX =0;
float mousePrevY =0;

String gcode_path = "parts/";
String code_path = "/Users/Bart/Desktop/TCD_gcode/contour.svg";

void setup() {
  size(1000, 1000);
  cp5 = new ControlP5(this);
  cp5.addSlider("angle")
    .setRange(0, 180)
    .setValue(90)
    .setPosition(20+0, 20)
    .setSize(100, 20)
    ;

  cp5.addSlider("baseFreq")
    .setRange(1, 10)
    .setValue(5)
    .setPosition(20+(100+10)*1, 20)
    .setSize(100, 20)
    .setLabel("base frequency")
    ;

  cp5.addSlider("baseAmp")
    .setRange(0, 50)
    .setValue(25)
    .setPosition(20+(100+10)*2, 20)
    .setSize(100, 20)
    .setLabel("base amplitude")
    ;

  cp5.addSlider("highFreq")
    .setRange(10, 200)
    .setValue(100)
    .setPosition(20+(100+10)*3, 20)
    .setSize(100, 20)
    .setLabel("finish frequency")
    ;

  cp5.addSlider("highAmp")
    .setRange(0, 10)   
    .setValue(1)
    .setPosition(20+(100+10)*4, 20)
    .setSize(100, 20)
    .setLabel("finish Amplitude")
    ;

  cp5.addSlider("sDist1")
    .setRange(0.1, nozzleDiameter*10)   
    .setValue(nozzleDiameter*3)
    .setPosition(20+(100+10)*5, 20)
    .setSize(100, 20)
    .setLabel("slicing distance start")
    ;

  cp5.addSlider("sDist2")
    .setRange(0.1, nozzleDiameter*10)   
    .setValue(nozzleDiameter*3)
    .setPosition(20+(100+10)*6, 20)
    .setSize(100, 20)
    .setLabel("slicing distance end")
    ;

  cp5.addBang("bang")
    .setPosition(width-80-20, height-40-20)
    .setSize(80, 40)
    .setTriggerEvent(Bang.RELEASE)
    .setLabel("save file")
    ;

  cp5.addBang("update")
    .setPosition(width-80-20, height-80-30)
    .setSize(80, 40)
    .setTriggerEvent(Bang.RELEASE)
    .setLabel("update")
    ;

  cp5.addBang("select")
    .setPosition(width-80-20, height-120-40)
    .setSize(80, 40)
    .setTriggerEvent(Bang.RELEASE)
    .setLabel("select file")
    ;
}

void draw() {
  if (change ==1) {
    change =0;
    viewUpdate();
  }
}

void mouseReleased() {
  mouseState =0;
}

void mouseWheel(MouseEvent event) {
  zoom += event.getCount();
  change = 1;
}

void mouseDragged() {
  if (mouseY>50) {
    if (mouseState ==0) {
      mousePrevX = mouseX;
      mousePrevY = mouseY;
      mouseState =1;
    }

    if (mouseX != mousePrevX) {
      println(mouseX, mousePrevX);
      viewPort[1] += (mousePrevX-mouseX);
      mousePrevX = mouseX;
    } 
    if (mouseY != mousePrevY) {
      println(mouseY, mousePrevY);
      viewPort[2] += (mousePrevY-mouseY);
      mousePrevY = mouseY;
    }

    change =1 ;
  }
}

void angle(float theValue) {
  angle = theValue;
}

void baseFreq(float theValue) {
  baseFreq = 1/theValue;
}

void highFreq(float theValue) {
  highFreq = 1/theValue;
}

void baseAmp(float theValue) {
  baseAmp = theValue;
}

void highAmp(float theValue) {
  highAmp = theValue;
}

void sDist1(float theValue) {
  sDist1 = theValue;
}

void sDist2(float theValue) {
  sDist2 = theValue;
}

void bang() {
  save();
}

void viewUpdate() {
  background(200);
  if (contour.length>0)
    drawEdgesMiddle(contour, zoom, viewPort);
  if (infill.length>0)
    drawEdgesMiddle(infill, zoom, viewPort);
}

void update() {
  contour = TWOD_ify(loadContours(code_path));
  if (sDist1 >0 && sDist2 >0) 
    infill = makeWaves(arrangeEdges(slicePolygon(contour, angle, sDist1, sDist2)), baseAmp, baseFreq, highAmp, highFreq);
  change = 1;
}

void select() {
  selectInput("Select a file to process:", "fileSelected");
  update();
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    code_path  = selection.getAbsolutePath();
  }
}

void saveGCODE() {
  startGcode();
  contour = TWOD_ify(loadContours(code_path));
  currentLayer = 0.5;


  float[] size = MaxMinPolygon(contour);
  float bX = (xSizeBuildplate -(size[2]-size[0]))/2;
  float bY = (ySizeBuildplate -(size[3]-size[1]))/2 ;
  fitShoe[1] = size[0] -bX;
  fitShoe[2] = size[1] -bY;

  slicedistance = nozzleDiameter;

  writeEdgesTranslated(contour, fitShoe);
  writeEdgesTranslated(infill, fitShoe);
  endGcode();
}

float[][] wave(float[] line, float amp1, float waves1, float amp2, float waves2) {
  float dist = dist(line[0], line[1], line[2], line[3]);
  int points = int((dist*DPMM)/0.1);

  float[][] newLine = new float[0][];
  for (int i =0; i<points; i++) {
    float[] point = new float[2];
    point[0] = lerp(line[0], line[2], float(i)/points);
    point[1] = lerp(line[1], line[3], float(i)/points) + sin(((point[0]-min(line[0], line[2]))*2*PI)/((max(line[0], line[2])-min(line[0], line[2]))*waves1))*amp1;
    newLine = append(newLine, point);
  }

  newLine = points2edges_open(newLine);
  newLine =finishwave(newLine, amp2, waves2);
  return newLine;
}

float[][] finishwave(float[][] edges, float amp, float waves) {
  float[][] newEdges = new float[0][];
  for (int i= 0; i< edges.length; i++) {
    float[] point = new float[4];
    point[0] = edges[i][0];
    point[1] = edges[i][1] + sin((i*2*PI)/((edges.length-1)*waves))*amp;
    point[2] = edges[i][2];
    point[3] = edges[i][3] + sin(((i+1)*2*PI)/((edges.length-1)*waves))*amp;
    if (point[0] != 0) 
      newEdges = append(newEdges, point);
  }
  return newEdges;
}

float[][] makeWaves (float[][] edges, float amp1, float waves1, float amp2, float waves2) {
  float[][] combined = new float[0][];

  for (int i =0; i<edges.length; i++) {
    combined = concat(combined, wave(edges[i], amp1, waves1, amp2, waves2));
  }
  return combined;
}

void drawEdgesMiddle(float[][] edges, float zoom, float[] translation) {
  float[] fit = new float[3];
  edges = scalePolygon(edges, (zoom/100)+1);
  float[] size = MaxMinPolygon(edges);
  float bX = (width -(size[2]-size[0]))/2;
  float bY = (height -(size[3]-size[1]))/2 ;
  fit[1] = size[0] -bX+translation[1];
  fit[2] = size[1] -bY+translation[2];

  drawEdges(translatePoints(edges, fit));
}    //   end drawEdges 