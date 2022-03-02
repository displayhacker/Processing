// See http://mathworld.wolfram.com/Epicycloid.html for more info
// NOTE: Click anywhere while this is running to cycle between the four available options

// Data structures
public class Point
{
  // Properties
  public float X;
  public float Y;
  
  // Constructor
  public Point(float x, float y) {
    this.X = x;
    this.Y = y;
  }
}

// Members
float k = 0; // Increment value
float kIncrement = 0.0005; // Bigger = faster, smaller = slower
float kIncrementSlow = kIncrement / 5; 
int pointTotal = 128; // Number of lines to draw each frame
Point[] circleStartPoints = new Point[pointTotal]; // Used to save the inital circle points
Point[] squareStartPoints = new Point[pointTotal]; // Used to save the inital circle points
int size = 512; // Edge of the square
int radius = 256; // Radius of the circle
int optionIndex = 0; // 0 = circle, circle; 1 = circle, square; 2 = square, circle; 3 = square, square

// Maths
public Point getCirclePoint(float radian) {
  // Get an equally-spaced point along the edge of a circle
  float x = radius * cos(radian) + radius;
  float y = radius * sin(radian) + radius;
  
  // Create the point and return it
  Point circlePoint = new Point(x, y);
  return circlePoint;
}

public Point getSquarePoint(float sector) {
  // Get an equally-spaced point along the edge of a square
  // Can this be simplified by max(abs(x), abs(y)) = size, or similar?
  // See http://polymathprogrammer.com/2010/03/01/answered-can-you-describe-a-square-with-1-equation/ for more information
  float x;
  float y;
  if (sector < 0.25) {
    x = (sector / 0.25) * size;
    y = 0;
  }
  else if (sector < 0.5) {
    x = size - 1;
    y = ((sector - 0.25) / 0.25) * size;
  }
  else if (sector < 0.75) {
    x = size - (((sector - 0.5) / 0.25) * size) - 1;
    y = size - 1;
  }
  else
  {
    x = 0;
    y = size - (((sector - 0.75) / 0.25) * size) - 1;
  }
  
  // Create the point and return it
  Point squarePoint = new Point(x, y);
  return squarePoint;
}

// Setup
public void setup() {
  // Size, color, etc.
  size(512, 512, P3D);
  stroke(0x60, 0x20, 0xC0);
  smooth(2);
  
  
  // Pre-calculate values, for each point in pointTotal...
  for (int i = 0; i < pointTotal; ++i) {
    // Get the values needed to create the start points
    float sector = (float)i / (float)pointTotal;
    float radian = sector * TWO_PI;
    
    
    // Calculate and save the start points
    circleStartPoints[i] = getCirclePoint(radian);
    squareStartPoints[i] = getSquarePoint(sector);
  }
}


// Draw
public void draw() {
  // Re-draw every frame
  background(0);
  
  // Draw the lines, for each point in pointTotal...
  for (int i = 0; i < pointTotal; ++i) {
    Point startPoint;
    Point endPoint;
    
    // Get the point to draw the line from
    switch (optionIndex) {
      case 0:
      case 1:
        // Circle start point
        startPoint = circleStartPoints[i];
        break;
      default:
        // Square start point
        startPoint = squareStartPoints[i];
        break;
    }
    
    // Get the point to draw the line to
    switch (optionIndex) {
      case 0:
      case 2:
        // Circle end point
        float radian = k * i;
        endPoint = getCirclePoint(radian);
        break;
      default:
        // Square end point
        float sector = (k * i) % 1;
        endPoint = getSquarePoint(sector);
        break;
    }
    
    // Draw the line
    line(startPoint.X, startPoint.Y, 0, endPoint.X, endPoint.Y, 0);
  }
  
  // Increment the line position, needs 2 speeds to look right
  switch (optionIndex) {
    case 0:
    case 2:
      k += kIncrement;
      break;
    default:
      k += kIncrementSlow;
      break;
  }
}

public void mouseClicked() {
  // Reset the incrementor to zero
  k = 0;
  
  
  // Increment the option index
  ++optionIndex;
  
  
  // Reset the option index if it is out of range
  if (optionIndex > 3)
    optionIndex = 0;
  
  // Change the line color
  switch (optionIndex) {
    case 0:
      stroke(0x60, 0x20, 0xC0);
      break;
    case 1:
      stroke(0x20, 0x60, 0xC0);
      break;
    case 2:
      stroke(0xC0, 0x60, 0x20);
      break;
    case 3:
      stroke(0xC0, 0x20, 0x60);
      break;
  }
}