private final float PHI = 0.5 + 0.5 * sqrt(5);
private final float SHAPE_COUNT = 8192;
private final float GOLDEN_ANGLE = TWO_PI * PHI;
private final float SIZE = 512;
private final float HALF_SIZE = SIZE * 0.5;
private final float AREA = sq(HALF_SIZE) * PI;
private final float MEAN_AREA = AREA / SHAPE_COUNT;
private final float DEVIATION = 5 / 8.0;
private final float MIN_AREA = MEAN_AREA * (1 - DEVIATION);
private final float MAX_AREA = MEAN_AREA * (1 + DEVIATION);
private final float DIFF_AREA = MAX_AREA - MIN_AREA;
private final float S = 0.8;
private final float B = 0.8;
private final float SIZE_SCALE = 1;
private final float HUE_OFFSET = PHI - 1;
private final float HUE_SCALE = -HUE_OFFSET / 1000000;
private final float SAT_OFFSET = (PHI - 1) * 1;
private final float SAT_SCALE = -HUE_OFFSET / 100000;
private final float BRI_OFFSET = (PHI - 1) * 1;
private final float BRI_SCALE = -HUE_OFFSET / 100000;

private Shape[] Shapes = new Shape[(int)SHAPE_COUNT];

public class Shape {
  public float X;
  public float Y;
  public int Index;
  public float Ratio;
  public float Angle;
  public float Size;
  public Shape(float x, float y, int index, float ratio, float angle, float size) {
    this.X = x;
    this.Y = y;
    this.Index = index;
    this.Ratio = ratio;
    this.Angle = angle;
    this.Size = size;
  }
  private color GetColor(float hueIncrement, float satIncrement, float briIncrement) {
    float hue = hueIncrement * this.Angle;
    hue -= floor(hue);
    /*float sat = satIncrement * this.Index;
    sat -= floor(sat);
    float bri = briIncrement * this.Angle;
    bri -= floor(bri);*/
    color fillColor = color(1 - hue, S, hue);
    return fillColor;
  }
  public void Draw(float hueIncrement, float satIncrement, float briIncrement) {
    fill(this.GetColor(hueIncrement, satIncrement, briIncrement));
    rect(this.X, this.Y, this.Size, this.Size);
  }
}

public void setup() {
  size(512, 512, P2D);
  colorMode(HSB, 1);
  noStroke();
  float cumulativeArea = 0;
  for (float i = 0; i < SHAPE_COUNT; ++i) {
    float ratio = i / SHAPE_COUNT;
    float angle = i * GOLDEN_ANGLE;
    
    float area = MIN_AREA + (ratio * DIFF_AREA);
    float diameter = 2 * sqrt(area / PI);
    float size = diameter * SIZE_SCALE;
    cumulativeArea += area;
    float radius = sqrt(cumulativeArea / PI);
    
    float offset = HALF_SIZE - (size * 0.5);
    float x = (cos(angle) * radius) + offset;
    float y = (sin(angle) * radius) + offset;
    
    Shape shape = new Shape(x, y, (int)i, ratio, angle, size);
    Shapes[(int)i] = shape;
  }
}

public void draw() {
  background(0);
  float hueIncrement = frameCount * HUE_SCALE + HUE_OFFSET;
  //float satIncrement = frameCount * SAT_SCALE + SAT_OFFSET;
  //float briIncrement = frameCount * BRI_SCALE + BRI_OFFSET;
  for (int i = 0; i < SHAPE_COUNT; ++i) {
    Shape shape = Shapes[i];
    shape.Draw(hueIncrement, 0, 0);
  }
}