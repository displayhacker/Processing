public class LineData {
  public float X1;
  public float Y1;
  public float X2;
  public float Y2;
  public LineData(float x1, float y1, float x2, float y2)
  {
    this.X1 = x1;
    this.Y1 = y1;
    this.X2 = x2;
    this.Y2 = y2;
  }
  public float getSlope() {
    float slope = (this.Y2 - this.Y1) / (this.X2 - this.X1);
    return slope;
  }
  public float getOffset(float m) {
    float offset = this.Y1 - (this.X1 * m);
    return offset;
  }
}

public PVector findIntersection(LineData line1, LineData line2) {
  float m1 = line1.getSlope();
  float m2 = line2.getSlope();
  float b1 = line1.getOffset(m1);
  float b2 = line2.getOffset(m2);
  float x = Math.abs((b1 - b2) / (m1 - m2));
  float y = Math.abs(b2 + m2 * x);
  PVector result = new PVector(x, y);
  return result;
}

void setup() {
  frameRate(30);
  size(1024, 768, P2D);
}

int t = 0;
int tIncrement = 1;
void draw() {
  t += tIncrement;
  
  background(0);
  stroke(255);
  float xMin = 0;
  float xMax = 1024;
  float x = xMin;
  float yMin = 0;
  float yMax = 768;
  float y = yMin;
  float incrementMin = 16;
  float incrementMax = 56;
  float increment = incrementMin + t;
  if (increment >= incrementMax || increment <= incrementMin) {
    tIncrement *= -1;
  }
  int lineArraySize = 4;
  LineData[] lineDataArray = new LineData[lineArraySize];
  
  for (int i = 0; i < lineArraySize; ++i) {
    float xStart = x;
    float yStart = y;
    switch (i) {
      case 0: // Top left to bottom left
        x += increment;
        y = yMax;
        break;
      case 1: // Bottom left to bottom right
        x = xMax;
        y -= increment;
        break;
      case 2: // Bottom right to top right
        x -= increment;
        y = yMin;
        break;
      case 3: // Top right to top left
        x = xMin;
        y += increment;
        break;
    }
    lineDataArray[i] = new LineData(xStart, yStart, x, y);
    if (i == lineArraySize - 1) {
      PVector intersection = findIntersection(lineDataArray[0], lineDataArray[i]);
      lineDataArray[i].X2 = intersection.x;
      lineDataArray[i].Y2 = intersection.y;
    }
    LineData drawLine = lineDataArray[i];
    line(drawLine.X1, drawLine.Y1, drawLine.X2, drawLine.Y2);
  }
  int iterationMax = (int)Math.floor((1 - (increment - incrementMin) / incrementMax) * 35);
  for (int i = 0; i < iterationMax; ++i) {
    for (int j = 0; j < lineArraySize; ++j) {
      LineData previousLine;
      LineData nextLine;
      int xSign;
      int ySign;
      switch (j) {
        case 0: // Top left to bottom left
          previousLine = lineDataArray[3];
          nextLine = lineDataArray[1];
          xSign = 1;
          ySign = -1;
          break;
        case 1: // Bottom left to bottom right
          previousLine = lineDataArray[0];
          nextLine = lineDataArray[2];
          xSign = -1;
          ySign = -1;
          break;
        case 2: // Bottom right to top right
          previousLine = lineDataArray[1];
          nextLine = lineDataArray[3];
          xSign = -1;
          ySign = 1;
          break;
        default: // Top right to top left
          previousLine = lineDataArray[2];
          nextLine = lineDataArray[0];
          xSign = 1;
          ySign = 1;
          break;
      }
      lineDataArray[j].X1 = previousLine.X2;
      lineDataArray[j].Y1 = previousLine.Y2;
      double angle = Math.atan(nextLine.getSlope());
      double side1 = xSign * Math.abs(increment * Math.cos(angle));
      double side2 = ySign * Math.abs(increment * Math.sin(angle));
      lineDataArray[j].X2 += side1;
      lineDataArray[j].Y2 += side2;
      PVector intersection = findIntersection(nextLine, lineDataArray[j]);
      lineDataArray[j].X2 = intersection.x;
      lineDataArray[j].Y2 = intersection.y;
      line(lineDataArray[j].X1, lineDataArray[j].Y1, lineDataArray[j].X2, lineDataArray[j].Y2);
    }
  }
}
