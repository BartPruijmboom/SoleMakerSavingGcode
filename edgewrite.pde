void edgeWrite(float startX, float startY, float endX, float endY) {
  //auxiliary for contourWrite and insoleWrite
  //write coordinates in mm
  if (startX > (0.05*DPMM) && endX > (0.05*DPMM)) {
    int L = 4;//digits before dot
    int R = 2;//digits after dot
    ext = ext + dist(startX, startY, endX, endY)*extrusionCoefficient;
    //    if (dist(prevX, prevY, startX, startY) <= 50) {
    if (prevX == endX && prevY == endY) {
    } else if (prevX==startX && prevY ==startY) {
      txt.println(" G1 X "+nf(endX / DPMM, L, R)+" Y "+nf(endY / DPMM, L, R)+" E "+nf(ext / DPMM, L, R)+ " Z " + nf(currentLayer));
    } else {
      txt.println("G1 X "+nf(startX / DPMM, L, R)+" Y "+nf(startY / DPMM, L, R)+ " Z " + nf(currentLayer));
      txt.println(" G1 X "+nf(endX / DPMM, L, R)+" Y "+nf(endY / DPMM, L, R)+" E "+nf(ext / DPMM, L, R) + " Z " + nf(currentLayer));
    }

    prevX = endX;
    prevY = endY;
  }
}

void writeEdgesTranslated(float[][] edges, float[] translation) {
  if (edges.length>0) {
    float[][] edges2 = translatePoints(edges, translation);
    //send them to the 3D printer, preserve the order of the edges: 0,1,...,edges.length-1
    for (int i = 0; i+1< edges2.length; i++) {
      float startX = edges2[i][0];
      float startY = edges2[i][1];
      float endX   = edges2[i][2];
      float endY   = edges2[i][3];
      edgeWrite(startX, startY, endX, endY);
    }    //end for
  }
}    //end writeEdges

void drawEdges(float[][] edges) {
  //send them to the screen
  for (int i = 0; i< edges.length; i++) {
    float startX = edges[i][0];
    float startY = edges[i][1];
    float endX   = edges[i][2];
    float endY   = edges[i][3];
    strokeWeight(.5);//thin
    line( startX, startY, endX, endY );
  }    //end for
}    //   end drawEdges 


float[][]
  scalePolygon(float[][] polygon, float scale) {
  float[] size = MaxMinPolygon(polygon);
  float gx = size[0];
  float gy = size[1];
  //now we have (gx,gy) being the midrange center
  //shrink everything towards the center
  float[][] scaled = new float[polygon.length][];
  for (int j = 0; j < polygon.length; j++) {
    float[] edge = new float[4];
    edge[0] = scale * polygon[j][0] + (1 - scale) * gx;
    edge[1] = scale * polygon[j][1] + (1 - scale) * gy;
    edge[2] = scale * polygon[j][2] + (1 - scale) * gx;
    edge[3] = scale * polygon[j][3] + (1 - scale) * gy; 
    scaled[j] = edge;//test only, was edge;
  }    //end for
  return scaled;
}    //end displayPolygon