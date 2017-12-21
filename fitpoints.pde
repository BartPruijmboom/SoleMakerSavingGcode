float[][] translatePoints(float[][] Shape, float[] translation) {

  float[][] shapePoints = new float[Shape.length][2];

  if (Shape[0].length==2) {
    float[] X1 = new float[Shape.length];
    float[] Y1 = new float[Shape.length];
    for (int i = 0; i<Shape.length; i++) {
      X1[i] = Shape[i][0];
      Y1[i] = Shape[i][1];
    };  

    float angle1= translation[0];
    float[] X3 = rotatePointsX(X1, Y1, angle1);
    float[] Y3 = rotatePointsY(X1, Y1, angle1);

    for (int j = 0; j<X1.length; j++) {
      X3[j] = X3[j]-translation[1];
      Y3[j] = Y3[j]-translation[2];
    }
    for (int i = 0; i<X3.length; i++) {
      shapePoints[i][0] = X3[i];
      shapePoints[i][1] = Y3[i];
    };
  } else {
    float[] X1 = new float[Shape.length];
    float[] Y1 = new float[Shape.length];
    float[] X2 = new float[Shape.length];
    float[] Y2 = new float[Shape.length];
    for (int i = 0; i<Shape.length; i++) {
      X1[i] = Shape[i][0];
      Y1[i] = Shape[i][1];
      X2[i] = Shape[i][2];
      Y2[i] = Shape[i][3];
    };  

    float angle1= translation[0];
    float[] X3 = rotatePointsX(X1, Y1, angle1);
    float[] Y3 = rotatePointsY(X1, Y1, angle1);
    float[] X4 = rotatePointsX(X2, Y2, angle1);
    float[] Y4 = rotatePointsY(X2, Y2, angle1);

    for (int j = 0; j<X2.length; j++) {
      X3[j] = X3[j]-translation[1];
      Y3[j] = Y3[j]-translation[2];
      X4[j] = X4[j]-translation[1];
      Y4[j] = Y4[j]-translation[2];
    }
    shapePoints = new float[Shape.length][4];
    for (int i = 0; i<X3.length; i++) {
      shapePoints[i][0] = X3[i];
      shapePoints[i][1] = Y3[i];
      shapePoints[i][2] = X4[i];
      shapePoints[i][3] = Y4[i];
    };
  }

  return shapePoints;
}

float[] rotatePoint (float X, float Y, float angle) {
  float x0 = 0;
  float y0 = 0;
  float AB=dist(x0, y0, X, Y);
  float angle2 =degrees( atan((Y-y0)/(X-x0)));
  float angle3 = 0;
  if (X>=x0) {
    angle3= 90-angle-angle2;
  } else {
    angle3= -90-angle-angle2;
  }

  float Y2= y0 + AB*cos(radians(angle3));
  float X2= x0 + AB*sin(radians(angle3));
  float[] rotatedPoint = {X2, Y2};
  return rotatedPoint;
}

float[] rotatePointsX(float[] X, float[] Y, float angle) {
  float x0 = 0;
  float y0 = 0;

  float[] X2 = new float[X.length];
  float[] Y2 = new float[Y.length];
  float angle3;
  for (int i =0; i<X.length; i++) {
    float AB=dist(x0, y0, X[i], Y[i]);
    float angle2 =degrees( atan((Y[i]-y0)/(X[i]-x0)));
    if (X[i]>=x0) {
      angle3= 90-angle-angle2;
    } else {
      angle3= -90-angle-angle2;
    }
    X2[i]= x0 + AB*sin(radians(angle3));
  }
  return X2;
}

float[] rotatePointsY(float[] X, float[] Y, float angle) {
  float x0 = 0;
  float y0 = 0;

  float[] X2 = new float[X.length];
  float[] Y2 = new float[Y.length];
  float angle3;
  for (int i =0; i<Y.length; i++) {
    float AB=dist(x0, y0, X[i], Y[i]);
    float angle2 =degrees( atan((Y[i]-y0)/(X[i]-x0)));
    if (X[i]>=x0) {
      angle3= 90-angle-angle2;
    } else {
      angle3= -90-angle-angle2;
    }
    Y2[i]= y0 + AB*cos(radians(angle3));
  }
  return Y2;
}