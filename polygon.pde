float[][] append(float[][] array1, float[] array2) {
  float [][] combinedArray = new float[array1.length+1][];
  float[][] array3 = new float[1][];
  array3[0]=array2;

  System.arraycopy(array1, 0, combinedArray, 0, array1.length);
  System.arraycopy(array3, 0, combinedArray, array1.length, array3.length);

  return combinedArray;
}

float[][][] append(float[][][] array1, float[][] array2) {
  float [][][] combinedArray = new float[array1.length+1][][];
  float[][][] array3 = new float[1][][];
  array3[0]=array2;

  System.arraycopy(array1, 0, combinedArray, 0, array1.length);
  System.arraycopy(array3, 0, combinedArray, array1.length, array3.length);

  return combinedArray;
}

float[][] concat(float[][] array1, float[][] array2) {
  float[][] outgoing = new float[array1.length+array2.length][];
  System.arraycopy(array1, 0, outgoing, 0, array1.length);
  System.arraycopy(array2, 0, outgoing, array1.length, array2.length);
  return outgoing;
}

float[][] remove(float array[][], int item) {
  float outgoing[][] = new float[array.length - 1][];
  System.arraycopy(array, 0, outgoing, 0, item);
  System.arraycopy(array, item+1, outgoing, item, array.length - (item + 1));
  return outgoing;
} 

float[][] arrangeEdges(float[][] edges) {
  float arrangedEdges[][] = new float[0][4];
  int OK =0;
  if (edges.length >1) {
    while (OK==0) {
      if (edges[0] != null) {
        OK =1;
      }
      edges = remove(edges, 0);
    }

    float[] startPoint = {prevX, prevY};
    int firstPoint = findClosestEdge(edges, startPoint);
    println(firstPoint);
    if (firstPoint<0) {
      float[] tmpPoint = {edges[-firstPoint][2], edges[-firstPoint][3], edges[-firstPoint][0], edges[-firstPoint][1]};
      arrangedEdges = append(arrangedEdges, tmpPoint);
      edges = remove(edges, -firstPoint);
    } else {
      arrangedEdges = append(arrangedEdges, edges[firstPoint]);
      edges = remove(edges, firstPoint);
    }


    while (edges.length>0) {
      float LOW =10000;
      int side = 2;
      int edge = 0;
      for (int i = 0; i<edges.length; i++) {
        //      println("YUP");
        if (dist(arrangedEdges[arrangedEdges.length-1][2], arrangedEdges[arrangedEdges.length-1][3], edges[i][0], edges[i][1]) < LOW) {
          edge = i;
          side = 0;
          LOW = dist(arrangedEdges[arrangedEdges.length-1][2], arrangedEdges[arrangedEdges.length-1][3], edges[i][0], edges[i][1]);
        };
        if (dist(arrangedEdges[arrangedEdges.length-1][2], arrangedEdges[arrangedEdges.length-1][3], edges[i][2], edges[i][3]) < LOW) {
          edge = i;
          side = 1;
          LOW = dist(arrangedEdges[arrangedEdges.length-1][2], arrangedEdges[arrangedEdges.length-1][3], edges[i][2], edges[i][3]);
        };
      }

      if (edges[edge]!=null) {
        float[] tmpEdge = new float[4];
        if (side == 0) {
          tmpEdge[0] = edges[edge][0];
          tmpEdge[1] = edges[edge][1];
          tmpEdge[2] = edges[edge][2];
          tmpEdge[3] = edges[edge][3];
          arrangedEdges = append(arrangedEdges, tmpEdge);
        } else if (side == 1) {
          tmpEdge[0] = edges[edge][2];
          tmpEdge[1] = edges[edge][3];
          tmpEdge[2] = edges[edge][0];
          tmpEdge[3] = edges[edge][1];
          arrangedEdges = append(arrangedEdges, tmpEdge);
        }
      }

      edges = remove(edges, edge);
    }
  }
  prevX = arrangedEdges[arrangedEdges.length-1][2];
  prevY = arrangedEdges[arrangedEdges.length-1][3];
  return arrangedEdges;
}

int findClosestEdge(float[][] array, float[] point) {
  int closest = -1;
  float dist = 100000;
  for (int i = 0; i< array.length; i++) {
    if (dist(array[i][0], array[i][1], point[0], point[1])<dist) {
      dist = dist(array[i][0], array[i][1], point[0], point[1]);
      closest = i;
    }
    if (dist(array[i][2], array[i][3], point[0], point[1])<dist) {
      dist = dist(array[i][2], array[i][3], point[0], point[1]);
      closest = -i;
    }
  }
  return closest;
}

float[][] TWOD_ify (float[][][] lines) {
  float[][] returnPoints = new float[0][];
  if (lines.length>0) {
    for (int i=0; i<lines.length; i++) {
      if (lines[i] != null) {
        returnPoints = concat(returnPoints, lines[i]);
      }
    }
  }
  return returnPoints;
}

float[][] reversePoints(float[][] array1) {
  float[][] outgoing = new float[array1.length][2];   
  for (int i =0; i<array1.length; i++) {
    outgoing[i][0] = array1[array1.length-1-i][0];
    outgoing[i][1] = array1[array1.length-1-i][1];
  }
  return outgoing;
}

float[][]
  slicePolygonX(float[][] polygon, float slicedistance1, float slicedistance2) {
  //assume constant slicedistance.
  //The polygon can be either a sole's contour or a tread.
  //We cannot work with polygons if one horzontal line has three or more intersects.
  //Convex polygons are safe, however.
  //The polygon must be given as an EQ-closed set of {x1,y1,x2,y2} edges.
  //Return a set of parallef edges to be printed with distance slicedistance
  if (polygon == null) return null;
  float[] size = MaxMinPolygon(polygon);
  //one horizontal edge for each Y:
  float[] scanline = new float[4];

  float[][] edges = new float[0][];//amount of lines (edges) that are being sliced

  for (float X = size[0]-1; X < size[2]+1; X += map(X, size[0], size[2], slicedistance1, slicedistance2)) { 
    scanline[0] = X; 
    scanline[1] = size[1] -100;
    scanline[2] = X;
    scanline[3] = size[3] + 100;
    int ISP = intersects(polygon, scanline);
    for (int i = 0; i+1<ISP; i=i+2) {
      float IP1 = givenintersectionpoint(polygon, scanline, i, 1);
      float IP2 = givenintersectionpoint(polygon, scanline, i+1, 1);
      //if (IP1 != 0 && IP2 != 0) {
      float Y1 = IP1;//0 is X, 1 is Y
      float Y2 = IP2;
      //should we check order? perhaps not
      float[] edge = new float[4];
      edge[0] = X;
      edge[1] = Y1;
      edge[2] = X;
      edge[3] = Y2;
      edges = append(edges, edge);
      //}    //end if
    }
  }    //end for
  return edges;
}    //end sclicePolygon

float[][] slicePolygon(float[][] contour, float angle, float slicedistance1, float slicedistance2) {
  float[] translation = {angle, 0, 0};
  contour = translatePoints(contour, translation);
  println("ok");
  float [][] slicedPolygons = slicePolygonX(contour, slicedistance1, slicedistance2);
  println("ok");
  float[] reverseTranslation = {-angle, 0, 0};
  float[][] angledSlicedPolygons = translatePoints(slicedPolygons, reverseTranslation);
  return angledSlicedPolygons;
};

float[][] append(float[][] array1, float x, float y) {
  float [][] combinedArray = new float[array1.length+1][];
  float[][] array3 = new float[1][2];
  array3[0][0]=x;
  array3[0][1]=y;

  System.arraycopy(array1, 0, combinedArray, 0, array1.length);
  System.arraycopy(array3, 0, combinedArray, array1.length, array3.length);

  return combinedArray;
}

float
  [][] points2edges(float[][] points) {
  //convert from point-based representation into edges
  float[][] edges = new float[points.length][4];
  float startX = points[0][0];
  float startY = points[0][1];
  for (int i = 1; i < points.length; i++) {
    float endX   = points[i][0];
    float endY   = points[i][1];
    edges[i - 1][0] = startX;
    edges[i - 1][1] = startY;
    edges[i - 1][2] = endX;
    edges[i - 1][3] = endY;
    startX = endX;
    startY = endY;
  }
  //close the loop
  edges[points.length - 1][0] = startX;
  edges[points.length - 1][1] = startY;
  edges[points.length - 1][2] = points[0][0];
  edges[points.length - 1][3] = points[0][1];
  return edges;
}

float [][] points2edges_open(float[][] points) {
  //convert from point-based representation into edges
  float[][] edges = new float[points.length][4];
  float startX = points[0][0];
  float startY = points[0][1];
  for (int i = 1; i < points.length; i++) {
    float endX   = points[i][0];
    float endY   = points[i][1];
    edges[i - 1][0] = startX;
    edges[i - 1][1] = startY;
    edges[i - 1][2] = endX;
    edges[i - 1][3] = endY;
    startX = endX;
    startY = endY;
  }
  return edges;
}

float[] MaxMinPolygon(float[][] polygon) {
  float[] sizes = new float[4];
  float minX=10000;
  float maxX=0;
  float minY=10000;
  float maxY=0;

  for (int i =0; i<polygon.length; i++) {
    if (polygon[i][0] < minX) {
      minX = polygon[i][0];
    }
    if (polygon[i][0] > maxX) {
      maxX = polygon[i][0];
    }

    if (polygon[i][1] < minY) {
      minY = polygon[i][1];
    }
    if (polygon[i][1] > maxY) {
      maxY = polygon[i][1];
    }
  }
  sizes[0] = minX;
  sizes[1] = minY;
  sizes[2] = maxX;
  sizes[3] = maxY;

  return sizes;
}