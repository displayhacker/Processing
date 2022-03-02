//private PFont FontCourierNew;
private int[][] PixelMap;
private color[] GradientValues;
private int T;
private PGraphics OffscreenRenderer;
private final int SIZE = 256;
private final int GRADIENT_RESOLUTION = 0x800;
//private final String FONT_COURIER_NEW_PATH = "CourierNewPSMT-12.vlw";


// Public Methods
public void setup() {
  size(512, 512, P2D);
  //FontCourierNew = loadFont(FONT_COURIER_NEW_PATH);
  
  OffscreenRenderer = createGraphics(SIZE, SIZE);
  
  int index = 0;
  PixelMap = new int[SIZE][SIZE];
  T = -600;
  
  for (int i = 0; i < SIZE; ++i) {
    PixelMap[i] = new int[SIZE];
    for (int j = 0; j < SIZE; ++j) {
      PixelMap[i][j] = index++;
    }
  }
  
  GradientValues = new color[GRADIENT_RESOLUTION];
  int[] gradientColors = {0, 0xFF8000, 0xFFFF80, 0xFFFFFF, 0x0080FF, 0x000080, 0};
  int gradientColorsMax = gradientColors.length - 1;
  float colorSize = 0;
  int colorSizeMax = floor((float)GRADIENT_RESOLUTION / (float)gradientColorsMax);
  for (int i = 0; i < GRADIENT_RESOLUTION; ++i) {
    float percent = (float)i / (float)GRADIENT_RESOLUTION;  
    int colorIndex = floor(percent * gradientColorsMax);
    int color1 = gradientColors[colorIndex];
    int color2 = gradientColors[colorIndex + 1];
    ++colorSize;
    if (colorSize > colorSizeMax) {
      colorSize = 0;
    }
    float inter = colorSize / colorSizeMax;
    color gradientColor = 0xFF000000 | lerpColor(color1, color2, inter);
    GradientValues[i] = gradientColor;
  }
}

public void draw() {
  OffscreenRenderer.beginDraw();
  OffscreenRenderer.background(0);
  OffscreenRenderer.loadPixels();
  for (int i = 0; i < SIZE; ++i) {
    for (int j = 0; j < SIZE; ++j) {
      float a = j;
      float x = i * cos(a);
      if (x < 0 || x >= SIZE)
        continue;
      
      float y = i * sin(a);
      if (y < 0 || y >= SIZE)
        continue;
      
      int c = ((i - T) * (j >> 1)) & (GRADIENT_RESOLUTION - 1);
      int index = PixelMap[(int)x][(int)y];
      OffscreenRenderer.pixels[index] = GradientValues[c];
    }
  }
  OffscreenRenderer.updatePixels();
  OffscreenRenderer.endDraw();
  translate(SIZE, SIZE);
  rotate(radians(90));
  image(OffscreenRenderer, 0, 0, SIZE, SIZE);
  rotate(radians(90));
  image(OffscreenRenderer, 0, 0, SIZE, SIZE);
  rotate(radians(90));
  image(OffscreenRenderer, 0, 0, SIZE, SIZE);
  rotate(radians(90));
  image(OffscreenRenderer, 0, 0, SIZE, SIZE);
  ++T;
}