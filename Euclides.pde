boolean intersects(float[] L1, float[] L2) {
  //local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
  //true if segment edge (xy1-xy2) intersects segment xy3-xy4 (s)
  double x1 = L1[0];//L1.X1
  double x2 = L1[2];//L1.X2
  double x3 = L2[0];//L2.X1
  double x4 = L2[2];//L2.X2
  double y1 = L1[1];//L1.Y1
  double y2 = L1[3];//L1.Y2
  double y3 = L2[1];//L2.Y1
  double y4 = L2[3];//L2.Y2
  double d =  ((y4 - y3)*(x2 - x1) - (x4 - x3)*(y2 - y1)); //"denominator"
  double f1 = ((x4 - x3)*(y1 - y3) - (y4 - y3)*(x1 - x3)) / d;//n_a
  double f2 = ((x2 - x1)*(y1 - y3) - (y2 - y1)*(x1 - x3)) / d;//n_b
  boolean isects = 0 < f1 && f1 <= 1 &&  0 < f2 && f2 <= 1;
  return isects;
}

float[] intersectionpoint(float[] L1, float[] L2) {
  //local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
  //true if segment edge (xy1-xy2) intersects segment xy3-xy4 (s)
  double x1 = L1[0];//L1.X1
  double x2 = L1[2];//L1.X2
  double x3 = L2[0];//L2.X1
  double x4 = L2[2];//L2.X2
  double y1 = L1[1];//L1.Y1
  double y2 = L1[3];//L1.Y2
  double y3 = L2[1];//L2.Y1
  double y4 = L2[3];//L2.Y2
  double d =  ((y4 - y3)*(x2 - x1) - (x4 - x3)*(y2 - y1)); //"denominator"
  double f1 = ((x4 - x3)*(y1 - y3) - (y4 - y3)*(x1 - x3)) / d;//n_a
  double f2 = ((x2 - x1)*(y1 - y3) - (y2 - y1)*(x1 - x3)) / d;//n_b
  boolean isects = 0 < f1 && f1 <= 1 &&  0 < f2 && f2 <= 1;
  if (isects) {
    float[] point = new float[2];
    point[0] = (float) (x1 + f1 * (x2-x1));
    point[1] = (float) (y1 + f1 * (y2-y1));
    return point;
  } else return null;
}

int intersects(float[][] edges, float[] edge) {
  //for given edges list (usually a contour), count how often segment s intersects it
  //where s is the segment from (sx1,sy1) to (sx2,sy2);
  int is = 0;
  for (int i = 0; i < edges.length; i++)
    if (intersects(edges[i], edge))
      is++;
  return is;
}

float[] intersectionpoint(float[][] edges, float[] edge) {
  //for given edges list (usually a contour), find a point where the segment intersects it
  boolean found = false;
  float point[] = null;
  for (int i = 0; i < edges.length && found == false; i++) {
    if (intersects(edges[i], edge)) {
      point = intersectionpoint(edges[i], edge);
      found = true;
    }   //end if
  }    //  end for
  return point;
}

float[] listintersectionpoints(float[][] edges, float[] edge, int direction) {    
  //for given edges list (usually a contour), find another point where the segment intersects it
  int count = 0;
  int ISP = intersects(edges, edge);
  //let's take the second (if any), not the first
  float[] points = new float[ISP];
  for (int i = 0; i < edges.length && count < ISP; i++) {
    if (intersects(edges[i], edge)) {
      float[] point = intersectionpoint(edges[i], edge);
      //      println(point[direction]);
      points[count] = point[direction];
      count++;
    }   //end if
  }    //  end for
  points=sort(points);
  return points;
}

float givenintersectionpoint(float[][] edges, float[] edge, int intersection, int direction) {
  //for given edges list (usually a contour), find another point where the segment intersects it
  float[] list = listintersectionpoints(edges, edge, direction);
  float point = list[intersection];
  return point;
}