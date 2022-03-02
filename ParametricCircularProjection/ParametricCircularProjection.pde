public class Point
{
  public float X;
  public float Y;
  public Point(float x, float y) {
    this.X = x;
    this.Y = y;
  }
}

private PFont FontCourierNew;
private int BackgroundColorGradientIndex;
private color[] GradientValues;
private color[][] GradientColors;
private int[][] PixelMap;
private int GradientColorIndex;
private int ButtonClickedIndex;
private float IncrementValue;
private float IncrementMax;
private float IncrementMin;
private float IncrementStep;
private float TIncrement = 0.995;
private float IIncrement = 1.0016;
private float JIncrement = 1.016;
private float TDefaultValue = 0;
private float T = TDefaultValue;
private float IncrementMaxDefault =  1;
private float IncrementMinDefault =  0.1;
private float IncrementStepDefault = 0.01;
private final int SIZE = 512;
private final int HALF_SIZE = SIZE >> 1;
private final int GRADIENT_RESOLUTION = SIZE << 2;
private final int TEXT_COLOR_DARK = #000000;
private final int BUTTON_DEFAULT_COLOR = #D4D0C8;
private final int BUTTON_HOVER_COLOR = #C0C0C0;
private final int TEXT_SIZE = 12;
private final int GRADIENT_COLOR_COUNT = 7;
private final int GRADIENT_OPTION_COUNT = 4;
private final int BUTTON_WIDTH = 72;
private final int BUTTON_HEIGHT = 24;
private final int BUTTON_X_MIN = 0;
private final int BUTTON_Y_MIN = 0;
private final int BUTTON_PADDING = 2;
private final String FONT_COURIER_NEW_PATH = "CourierNewPSMT-12.vlw";


// Public Methods
public void setup() {
  size(512, 512, P2D);
  
  FontCourierNew = loadFont(FONT_COURIER_NEW_PATH);
  BackgroundColorGradientIndex = 0;
  
  resetIncrements();
  configurePixelMap();
  initGradients();
}

private void resetIncrements() {
  print("resetIncrements\n"); //<>//
  T = TDefaultValue;
  IncrementValue = IncrementMinDefault;
  IncrementMax = IncrementMaxDefault;
  IncrementMin = IncrementMinDefault;
  IncrementStep = IncrementStepDefault;
}

private void configurePixelMap() {
  int index = 0;
  PixelMap = new int[SIZE][SIZE];
  for (int i = 0; i < SIZE; ++i) {
    for (int j = 0; j < SIZE; ++j) {
      PixelMap[i][j] = index++;
    }
  } //<>//
}

private void initGradients() {
  GradientValues = new color[GRADIENT_RESOLUTION];
  GradientColors = new color[GRADIENT_OPTION_COUNT][GRADIENT_COLOR_COUNT];
  GradientColors[0] = new color[] { color(0), color(0xFF8000), color(0xFFFF80), color(0xFFFFFF), color(0x0080FF), color(0x000080), color(0) };
  GradientColors[1] = new color[] { color(0), color(0x8000FF), color(0xFF80FF), color(0xFFFFFF), color(0x80FF00), color(0x008000), color(0) };
  GradientColors[2] = new color[] { color(0xFFFFE0), color(0xFDC453), color(0xEBA32B), color(0x302008), color(0xDE8C0E), color(0xF4B242), color(0xFFFFE0) };
  GradientColors[3] = new color[] { color(0x004020), color(0x0080C0), color(0x00C080), color(0x002040), color(0x00C020), color(0x0080C0), color(0x004020) };
  resetGradients();
}

private void resetGradients() {
  color[] selectedGradientColors = GradientColors[GradientColorIndex];
  int gradientColorsMax = GRADIENT_COLOR_COUNT - 1;
  float colorSize = 0;
  int colorSizeMax = floor((float)GRADIENT_RESOLUTION / (float)gradientColorsMax);
  for (int i = 0; i < GRADIENT_RESOLUTION; ++i) {
    float percent = (float)i / (float)GRADIENT_RESOLUTION;  
    int colorIndex = floor(percent * gradientColorsMax);
    int color1 = selectedGradientColors[colorIndex];
    int color2 = selectedGradientColors[colorIndex + 1];
    ++colorSize;
    if (colorSize > colorSizeMax) {
      colorSize = 0;
    }
    float inter = colorSize / colorSizeMax;
    color gradientColor = lerpColor(color1, color2, inter);
    GradientValues[i] = gradientColor;
  }
}

public void draw() {
  drawBackground();
  drawButtons();
  drawMainContent();
}

private void drawBackground() {
  background(GradientValues[BackgroundColorGradientIndex]); //<>//
}

private void drawButtons() {
  int xLeftMin = BUTTON_X_MIN;                       //   0 //<>//
  int xLeftMax = BUTTON_WIDTH;                       //  72
  
  int xRightMin = SIZE - BUTTON_WIDTH;               // 440
  int xRightMax = SIZE;                              // 512
  
  int yTop1Min = BUTTON_Y_MIN;                       //   0
  int yTop1Max = BUTTON_HEIGHT;                      //  24
  
  int yTop2Min = BUTTON_PADDING + yTop1Max;          //  26
  int yTop2Max = BUTTON_HEIGHT + yTop2Min;           //  50
  
  int yTop3Min = BUTTON_PADDING + yTop2Max;          //  52
  int yTop3Max = BUTTON_HEIGHT + yTop3Min;           //  76
  
  int topLeft1FillColor = BUTTON_DEFAULT_COLOR;
  int topLeft2FillColor = BUTTON_DEFAULT_COLOR;
  int topLeft3FillColor = BUTTON_DEFAULT_COLOR;
  int topRight1FillColor = BUTTON_DEFAULT_COLOR;
  int topRight2FillColor = BUTTON_DEFAULT_COLOR;
  int topRight3FillColor = BUTTON_DEFAULT_COLOR;
  
  int topLeft1Index = 0;
  int topLeft2Index = 1;
  int topLeft3Index = 2;
  int topRight1Index = 3;
  int topRight2Index = 4;
  int topRight3Index = 5;
  
  ButtonClickedIndex = -1;
  
  // Left buttons
  if (mouseX >= xLeftMin && mouseX <= xLeftMax) {
    // Top
    if (mouseY >= yTop1Min && mouseY <= yTop1Max) {
      topLeft1FillColor = BUTTON_HOVER_COLOR;
      ButtonClickedIndex = topLeft1Index;
    // 2nd from top
    } else if (mouseY >= yTop2Min && mouseY <= yTop2Max) {
      topLeft2FillColor = BUTTON_HOVER_COLOR;
      ButtonClickedIndex = topLeft2Index;
    // 3rd from top
    } else if (mouseY >= yTop3Min && mouseY <= yTop3Max) {
      topLeft3FillColor = BUTTON_HOVER_COLOR;
      ButtonClickedIndex = topLeft3Index;
    }
  // Right buttons
  } else if (mouseX >= xRightMin && mouseX <= xRightMax) {
    // Top
    if (mouseY >= yTop1Min && mouseY <= yTop1Max) {
      topRight1FillColor = BUTTON_HOVER_COLOR;
      ButtonClickedIndex = topRight1Index;
    // 2nd from top
    } else if (mouseY >= yTop2Min && mouseY <= yTop2Max) {
      topRight2FillColor = BUTTON_HOVER_COLOR;
      ButtonClickedIndex = topRight2Index;
    // 3rd from top
    } else if (mouseY >= yTop3Min && mouseY <= yTop3Max) {
      topRight3FillColor = BUTTON_HOVER_COLOR;
      ButtonClickedIndex = topRight3Index;
    }
  }
  
  drawButton("T " + nf(T, 1, 1),                  xLeftMin, yTop1Min, BUTTON_WIDTH, BUTTON_HEIGHT, topLeft1FillColor);
  drawButton("T+ " + nf(TIncrement, 1, 3),        xLeftMin, yTop2Min, BUTTON_WIDTH, BUTTON_HEIGHT, topLeft2FillColor);
  drawButton("Colors: " + nf(GradientColorIndex), xLeftMin, yTop3Min, BUTTON_WIDTH, BUTTON_HEIGHT, topLeft3FillColor);
  
  drawButton("I+" + nf(IIncrement, 1, 4),         xRightMin, yTop1Min, BUTTON_WIDTH, BUTTON_HEIGHT, topRight1FillColor);
  drawButton("J+" + nf(JIncrement, 1, 4),         xRightMin, yTop2Min, BUTTON_WIDTH, BUTTON_HEIGHT, topRight2FillColor);
  drawButton("s" + nf(abs(IncrementStep), 0, 5),  xRightMin, yTop3Min, BUTTON_WIDTH, BUTTON_HEIGHT, topRight3FillColor);
}

private void drawButton(String text, int x, int y, int width, int height, int fillColor) {
  int textColor = TEXT_COLOR_DARK;
  fill(fillColor);
  rect(x, y, width, height);
  fill(textColor);
  textAlign(CENTER);
  textFont(FontCourierNew);
  textSize(TEXT_SIZE);
  text(text, x, y + TEXT_SIZE, width, height);
}

public void mouseClicked() {
  boolean shiftClick = keyPressed && keyCode == SHIFT;
  int incrementAmount = shiftClick ? -1 : 1;
  float minValue, amount;
  switch (ButtonClickedIndex) {
    case 0:
      print("Reset Increments\n");
      resetIncrements();
      break;
    case 1:
      print("Increment TIncrement\n");
      minValue = 0.001;
      amount = incrementAmount * minValue;
      TIncrement += amount;
      if (TIncrement < minValue) {
        TIncrement = minValue;
      }
      break;
    case 2:
      print("Gradient Colors\n");
      GradientColorIndex += incrementAmount;
      if (GradientColorIndex >= GRADIENT_OPTION_COUNT) {
        GradientColorIndex = 0;
      } else if (GradientColorIndex < 0) {
        GradientColorIndex = GRADIENT_OPTION_COUNT - 1;
      }
      resetGradients();
      break;
    case 3:
      print("Increment IIncrement\n");
      minValue = 0.0001;
      amount = incrementAmount * minValue;
      IIncrement += amount;
      if (IIncrement < minValue) {
        IIncrement = minValue;
      }
      break;
    case 4:
      print("Increment JIncrement\n");
      minValue = 0.001;
      amount = incrementAmount * minValue;
      JIncrement += amount;
      if (JIncrement < minValue) {
        JIncrement = minValue;
      }
      break;
    case 5:
      print("Increment Step\n");
      minValue = 0.00001;
      amount = incrementAmount * minValue;
      IncrementStep += amount;
      if (IncrementStep < minValue) {
        IncrementStep = minValue;
      }
      break;
  }
}

private void drawMainContent() {
  loadPixels();
  for (float i = -HALF_SIZE; i < HALF_SIZE; i += IIncrement) {
    for (float j = -HALF_SIZE; j < HALF_SIZE; j += IIncrement) {
      float a = i + T;
      int x = round(j * cos(a)) + HALF_SIZE;
      if (x < 0 || x >= SIZE) {
        continue;
      }
      
      int y = round(j * sin(a)) + HALF_SIZE;
      if (y < 0 || y >= SIZE) {
        continue;
      }
      
      int c = floor((j - T) * (i * 0.5)) & (GRADIENT_RESOLUTION - 1);
      int pixelIndex = PixelMap[x][y];
      color gradientColor = GradientValues[c];
      pixels[pixelIndex] = gradientColor;
    }
  }
  updatePixels();
  
  /*if (++BackgroundColorGradientIndex >= GRADIENT_RESOLUTION) {
    BackgroundColorGradientIndex = 0;
  }*/
  
  T += TIncrement;
  
  /*IncrementValue += IncrementStep;
  if (IncrementValue >= IncrementMax) {
    IncrementValue = IncrementMin;
  } else if (IncrementValue < IncrementMin) {
    IncrementValue = IncrementMax;
  }*/
}