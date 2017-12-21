float[][][] loadContours(String SVGShape) {
  RG.init(this);
  RG.setPolygonizer(RG.ADAPTATIVE); 
  RShape grp;
  grp = RG.loadShape(SVGShape);
  grp.centerIn(g, 0, 0, 0);
  RPoint[][] pointPaths;
  pointPaths = grp.getPointsInPaths();

  float[][][] 
    paths = new float[0][][];

  for (int i =0; i<pointPaths.length; i++) {
    if (pointPaths[i] != null) {
      //if (pointPaths[i].length>7) {
      float[][] path = new float[0][];
      for (int j = 0; j<pointPaths[i].length; j++) {
        float[] point = {pointPaths[i][j].x, pointPaths[i][j].y};
        path = append(path, point);
      }
      path =redistributeEdges(path, 2, 0);
      paths = append(paths, path);
      //}
    }
  }

  return paths;
}

float[][] redistributePoints (float[][] contourPoints, float distance, int state) {
  AUCurve MyCurve;
  MyCurve = new AUCurve(contourPoints, 2, true);

  float[][] returnPoints = new float[0][];

  if (state ==0) {
    int numReturnPointsSteps = pathPoints(contourPoints, distance);
    returnPoints = new float[numReturnPointsSteps][2];

    for (int i = 0; i < numReturnPointsSteps; i++) {
      float t = norm(i, 0, numReturnPointsSteps-1);
      returnPoints[i][0] = MyCurve.getX(t);
      returnPoints[i][1] = MyCurve.getY(t);
    }
  } else if (state ==1) {
    int numReturnPointsSteps = int(distance);
    returnPoints = new float[numReturnPointsSteps][2];

    for (int i = 0; i < numReturnPointsSteps; i++) {
      float t = norm(i, 0, numReturnPointsSteps-1);
      returnPoints[i][0] = MyCurve.getX(t);
      returnPoints[i][1] = MyCurve.getY(t);
    }
  } else if (state ==2) {
    for (int i = 0; i<contourPoints.length; i++) {
      float dist = dist(contourPoints[i][0], contourPoints[i][1], contourPoints[i][2], contourPoints[i][3]);
      int points = int(dist/distance); 
      for (int j = 0; j<points; j++) {
        float[] point = {lerp(j/points, contourPoints[i][0], contourPoints[i][2]), lerp(j/points, contourPoints[i][1], contourPoints[i][3])};
        returnPoints = append(returnPoints, point);
      }
    }
  }

  return returnPoints;
}

int pathPoints(float[][] contour, float distance) {
  float pathLength = pathLength(contour);
  int numReturnPointsSteps = int(pathLength/distance);
  return numReturnPointsSteps;
}

float pathLength(float[][] contour) {
  AUCurve MyCurve;
  MyCurve = new AUCurve(contour, 2, true);
  int numPathLengthPoints = 1000;
  float pathLength = 0;

  for (int i = 1; i < numPathLengthPoints; i++) {
    float t = norm(i, 0, numPathLengthPoints);
    float tx = norm(i-1, 0, numPathLengthPoints);
    pathLength = pathLength + dist(MyCurve.getX(tx), MyCurve.getY(tx), MyCurve.getX(t), MyCurve.getY(t));
  }

  return pathLength;
}

float[][] redistributeEdges(float[][] contourEdges, float distance, int state) {
  float[][] redistributedPoints = redistributePoints(contourEdges, distance, state);
  float[][] returnEdges = points2edges(redistributedPoints);
  return returnEdges;
}