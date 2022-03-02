// Constants
private final String SAW = "saw";
private final String SIN = "sin";
private final String COS = "cos";
private final String TAN = "tan";
private final String ASIN = "asin";
private final String ACOS = "acos";
private final String ATAN = "atan";
private final String SINH = "sinh";
private final String COSH = "cosh";
private final String TANH = "tanh";
private final String MULTIPLICATION = "*";
private final String ADDITION = "+";
private final String SUBTRACTION = "-";
private final String I_K = "i*K";
private final String I_MINUS_K = "i-K";
private final String I_PLUS_K = "i+K";
private final String ONE_OVER_I_K = "I*K";
private final String ONE_OVER_I_MINUS_K = "I-K";
private final String ONE_OVER_I_PLUS_K = "I+K";
private final String DRAW_ELLIPSE = "●";
private final String DRAW_RECTANGLE = "■";


// Properties
private float K_COUNTER = 0;
private float K_SIGN = 1;
private float STEP_INCREMENT;
private float STEP_MAX;
private int SIZE = 512;
private int HALF_SIZE = SIZE >> 1;
private int BACKGROUND_COLOR = #000000;
private int TEXT_COLOR_DARK = #000000;
private int TEXT_COLOR_RED = #FF0000;
private int TEXT_SIZE = 12;
private int BUTTON_DEFAULT_COLOR = #D4D0C8;
private int BUTTON_HOVER_COLOR = #C0C0C0;
private int BUTTON_PADDING = 16;
private int BUTTON_SIZE = 32;
private int BUTTON_CLICKED_INDEX = -1;
private int BUTTON_COUNT_HORIZONTAL = 5;
private PFont FONT_COURIER_NEW;


// Parameters
private String xAFunction = SIN;
private String xAInput = I_MINUS_K;
private String xOperator = MULTIPLICATION;
private String xBFunction = SIN;
private String xBInput = I_K;

private String yAFunction = COS;
private String yAInput = I_PLUS_K;
private String yOperator = MULTIPLICATION;
private String yBFunction = COS;
private String yBInput = I_K;

private float kMax = 4;
private int stepIncrementValue = 512;
private int stepMaxValue = 16;
private int unitSizeMax = 16;
private int unitSizeMultiplier = 12;

private float K = 0;
private float kIncrement = PI / (2 << 10);
private String incrementType = SAW;
private String drawType = DRAW_RECTANGLE;


// Public Methods
public void setup() {
  size(768, 512, P2D);
  noStroke();
  FONT_COURIER_NEW = loadFont("CourierNewPSMT-12.vlw");
  setStepIncrement(stepIncrementValue);
  setStepMax(stepMaxValue);
}

public void draw() {
  drawUI();
  drawPrimaryData();
}


// Helper Methods
private void drawUI() {
  background(BACKGROUND_COLOR);
  drawButtons();
}

private void drawButton(int x, int y, int size, int index, int fillColor) {
  String text = "";
  int textColor = TEXT_COLOR_DARK;
  switch (index) {
    case 0:
      text = xAFunction;
      break;
    case 1:
      text = xAInput;
      break;
    case 2:
      text = xOperator;
      break;
    case 3:
      text = xBFunction;
      break;
    case 4:
      text = xBInput;
      break;
    case 5:
      text = yAFunction;
      break;
    case 6:
      text = yAInput;
      break;
    case 7:
      text = yOperator;
      break;
    case 8:
      text = yBFunction;
      break;
    case 9:
      text = yBInput;
      break;
    case 10:
      text = nf(kMax);
      break;
    case 11:
      text = nf(stepIncrementValue);
      break;
    case 12:
      text = nf(stepMaxValue);
      break;
    case 13:
      text = nf(unitSizeMax);
      break;
    case 14:
      text = nf(unitSizeMultiplier);
      break;
    case 15:
      if (K < 0)
        textColor = TEXT_COLOR_RED;
      
      text = nf(abs(K), 1, 2);
      break;
    case 16:
      text = nf(round(log(PI / kIncrement) / log(2)));
      break;
    case 17:
      text = incrementType;
      break;
    case 18:
      text = drawType;
      break;
    case 19:
      text = "@";
      break;
    default:
      return;
  }
  
  fill(fillColor);
  rect(x, y, size, size);
  fill(textColor);
  textAlign(CENTER);
  textFont(FONT_COURIER_NEW);
  textSize(TEXT_SIZE);
  text(text, x, y + TEXT_SIZE, size, size);
}

private void drawButtons() {
  int xMin = SIZE + BUTTON_PADDING;
  int xMax = xMin + BUTTON_SIZE;
  int xIncrement = BUTTON_PADDING + BUTTON_SIZE;
  int yTopMin = BUTTON_PADDING;
  int yTopMax = yTopMin + BUTTON_SIZE;
  int yUpperMiddleMin = yTopMax + BUTTON_PADDING;
  int yUpperMiddleMax = yUpperMiddleMin + BUTTON_SIZE;
  int yLowerMiddleMin = yUpperMiddleMax + BUTTON_PADDING;
  int yLowerMiddleMax = yLowerMiddleMin + BUTTON_SIZE;
  int yBottomMin = yLowerMiddleMax + BUTTON_PADDING;
  int yBottomMax = yBottomMin + BUTTON_SIZE;
  BUTTON_CLICKED_INDEX = -1;
  
  for (int i = 0; i < BUTTON_COUNT_HORIZONTAL; ++i) {
    int fillColorTop =         BUTTON_DEFAULT_COLOR;
    int fillColorUpperMiddle = BUTTON_DEFAULT_COLOR;
    int fillColorLowerMiddle = BUTTON_DEFAULT_COLOR;
    int fillColorBottom =      BUTTON_DEFAULT_COLOR;
    int topIndex =             0 * BUTTON_COUNT_HORIZONTAL + i;
    int upperMiddleIndex =     1 * BUTTON_COUNT_HORIZONTAL + i;
    int lowerMiddleIndex =     2 * BUTTON_COUNT_HORIZONTAL + i;
    int bottomIndex =          3 * BUTTON_COUNT_HORIZONTAL + i;
    
    if (mouseX >= xMin && mouseX <= xMax) {
      if (mouseY >= yTopMin && mouseY <= yTopMax) {
        fillColorTop = BUTTON_HOVER_COLOR;
        BUTTON_CLICKED_INDEX = topIndex;
      } else if (mouseY >= yUpperMiddleMin && mouseY <= yUpperMiddleMax) {
        fillColorUpperMiddle = BUTTON_HOVER_COLOR;
        BUTTON_CLICKED_INDEX = upperMiddleIndex;
      } else if (mouseY >= yLowerMiddleMin && mouseY <= yLowerMiddleMax) {
        fillColorLowerMiddle = BUTTON_HOVER_COLOR;
        BUTTON_CLICKED_INDEX = lowerMiddleIndex;
      } else if (mouseY >= yBottomMin && mouseY <= yBottomMax) {
        fillColorBottom = BUTTON_HOVER_COLOR;
        BUTTON_CLICKED_INDEX = bottomIndex;
      }
    }
    
    drawButton(xMin, yTopMin,         BUTTON_SIZE, topIndex,         fillColorTop);
    drawButton(xMin, yUpperMiddleMin, BUTTON_SIZE, upperMiddleIndex, fillColorUpperMiddle);
    drawButton(xMin, yLowerMiddleMin, BUTTON_SIZE, lowerMiddleIndex, fillColorLowerMiddle);
    drawButton(xMin, yBottomMin,      BUTTON_SIZE, bottomIndex,      fillColorBottom);
    
    xMin += xIncrement;
    xMax += xIncrement;
  }
}

private String incrementFunction(String function) {
  switch (function) {
    case SIN:
      function = COS;
      break;
    case COS:
      function = TAN;
      break;
    case TAN:
      function = ASIN;
      break;
    case ASIN:
      function = ACOS;
      break;
    case ACOS:
      function = ATAN;
      break;
    case ATAN:
      function = SINH;
      break;
    case SINH:
      function = COSH;
      break;
    case COSH:
      function = TANH;
      break;
    case TANH:
      function = SIN;
      break;
  }
  
  return function;
}

private String incrementInput(String input) {
  switch (input) {
    case I_K:
      input = I_PLUS_K;
      break;
    case I_PLUS_K:
      input = I_MINUS_K;
      break;
    case I_MINUS_K:
      input = ONE_OVER_I_K;
      break;
    case ONE_OVER_I_K:
      input = ONE_OVER_I_PLUS_K;
      break;
    case ONE_OVER_I_PLUS_K:
      input = ONE_OVER_I_MINUS_K;
      break;
    case ONE_OVER_I_MINUS_K:
      input = I_K;
      break;
  }
  
  return input;
}

private String incrementOperator(String operator) {
  switch (operator) {
    case MULTIPLICATION:
      operator = ADDITION;
      break;
    case ADDITION:
      operator = SUBTRACTION;
      break;
    case SUBTRACTION:
      operator = MULTIPLICATION;
      break;
  }
  
  return operator;
}

private String incrementIncrementType(String incrementType) {
  switch (incrementType) {
    case SIN:
      incrementType = SAW;
      break;
    case SAW:
      incrementType = SIN;
      break;
  }
  
  return incrementType;
}

private float incrementKMax(float value) {
  if (value >= 8)
    value = 1;
  else
    value++;
  
  return value;
}

private int incrementStepIncrementValue(int value) {
  if (value >= 0x400)
    value = 0x40;
  else
    value += 0x40;
    
  return value;
}

private int incrementStepMaxValue(int value) {
  if (value >= 32)
    value = 2;
  else
    value += 2;
  
  return value;
}

private int incrementUnitSizeMax(int value) {
  if (value >= 32)
    value = 2;
  else
    ++value;
  
  return value;
}

private int incrementUnitSizeMultiplier(int value) {
  if (value >= 32)
    value = 2;
  else
    ++value;
  
  return value;
}

private float incrementKIncrement(float value) {
  if (value >= PI / 1024)
    value = PI / 65536;
  else
    value *= 2;
  
  return value;
}

private String incrementDrawType(String value) {
  switch (value) {
    case DRAW_ELLIPSE:
      value = DRAW_RECTANGLE;
      break;
    case DRAW_RECTANGLE:
      value = DRAW_ELLIPSE;
      break;
  }
  
  return value;
}

public void mouseClicked() {
  switch (BUTTON_CLICKED_INDEX) {
    case 0:
      xAFunction = incrementFunction(xAFunction);
      break;
    case 1:
      xAInput = incrementInput(xAInput);
      break;
    case 2:
      xOperator = incrementOperator(xOperator);
      break;
    case 3:
      xBFunction = incrementFunction(xBFunction);
      break;
    case 4:
      xBInput = incrementInput(xBInput);
      break;
    case 5:
      yAFunction = incrementFunction(yAFunction);
      break;
    case 6:
      yAInput = incrementInput(yAInput);
      break;
    case 7:
      yOperator = incrementOperator(yOperator);
      break;
    case 8:
      yBFunction = incrementFunction(yBFunction);
      break;
    case 9:
      yBInput = incrementInput(yBInput);
      break;
    case 10:
      kMax = incrementKMax(kMax);
      resetK();
      break;
    case 11:
      stepIncrementValue = incrementStepIncrementValue(stepIncrementValue);
      setStepIncrement(stepIncrementValue);
      break;
    case 12:
      stepMaxValue = incrementStepMaxValue(stepMaxValue);
      setStepMax(stepMaxValue);
      break;
    case 13:
      unitSizeMax = incrementUnitSizeMax(unitSizeMax);
      break;
    case 14:
      unitSizeMultiplier = incrementUnitSizeMultiplier(unitSizeMultiplier);
      break;
    case 15:
      resetK();
      break;
    case 16:
      kIncrement = incrementKIncrement(kIncrement);
      break;
    case 17:
      incrementType = incrementIncrementType(incrementType);
      resetK();
      break;
    case 18:
      drawType = incrementDrawType(drawType);
      break;
    case 19:
      resetControls();
      break;
  }
}

private void setStepIncrement(int value) {
  STEP_INCREMENT = PI / value;
}

private void setStepMax(int value) {
  STEP_MAX = PI * value;
}

private void drawPrimaryData() {
  translate(HALF_SIZE, HALF_SIZE);
  
  for (float i = 0; i < STEP_MAX; i += STEP_INCREMENT) {
    float iK = i * K;
    float iMinusK = i - K;
    float iPlusK = i + K;
    float oneOverI = 1 / i;
    float oneOverIK = oneOverI * K;
    float oneOverIMinusK = oneOverI - K;
    float oneOverIPlusK = oneOverI + K;
    float xA = getOperand(iMinusK, iPlusK, iK, oneOverIK, oneOverIMinusK, oneOverIPlusK, xAInput, xAFunction);
    float xB = getOperand(iMinusK, iPlusK, iK, oneOverIK, oneOverIMinusK, oneOverIPlusK, xBInput, xBFunction);
    float x = operate(xA, xB, xOperator);
    float yA = getOperand(iMinusK, iPlusK, iK, oneOverIK, oneOverIMinusK, oneOverIPlusK, yAInput, yAFunction);
    float yB = getOperand(iMinusK, iPlusK, iK, oneOverIK, oneOverIMinusK, oneOverIPlusK, yBInput, yBFunction);
    float y = operate(yA, yB, yOperator);
    float proportion = (x + 1) / 2;
    float size = unitSizeMax - (proportion * unitSizeMultiplier);
    float colorValue = proportion * 0xFF;
    
    fill(colorValue, 0, 0xFF - colorValue);
    
    switch (drawType) {
      case DRAW_ELLIPSE:
        ellipse(y * HALF_SIZE, x * HALF_SIZE, size, size);
        break;
      case DRAW_RECTANGLE:
        rect(y * HALF_SIZE, x * HALF_SIZE, size, size);
        break;
    }
    
    rotate(STEP_INCREMENT);
  }
  
  incrementK();
}

private float getOperand(float iMinusK, float iPlusK, float iK, float oneOverIK, float oneOverIMinusK, float oneOverIPlusK, String input, String function) {
  float output = 0;
  
  switch (input) {
      case I_MINUS_K:
        output = iMinusK;
        break;
      case I_PLUS_K:
        output = iPlusK;
        break;
      case I_K:
        output = iK;
        break;
      case ONE_OVER_I_K:
        output = oneOverIK;
        break;
      case ONE_OVER_I_MINUS_K:
        output = oneOverIMinusK;
        break;
      case ONE_OVER_I_PLUS_K:
        output = oneOverIPlusK;
        break;
    }
    
    switch (function) {
      case SIN:
        output = sin(output);
        break;
      case COS:
        output = cos(output);
        break;
      case TAN:
        output = tan(output);
        break;
      case ASIN:
        output = asin(output);
        break;
      case ACOS:
        output = acos(output);
        break;
      case ATAN:
        output = atan(output);
        break;
      case SINH:
        output = (float)Math.sinh(output);
        break;
      case COSH:
        output = (float)Math.cosh(output);
        break;
      case TANH:
        output = (float)Math.tanh(output);
        break;
    }
    
    return output;
}

private float operate(float operandA, float operandB, String operator) {
  float output = 0;
  
  switch (operator) {
    case MULTIPLICATION:
      output = operandA * operandB;
      break;
    case ADDITION:
      output = operandA + operandB;
      break;
    case SUBTRACTION:
      output = operandA - operandB;
      break;
  }
  
  return output;
}

private void resetControls() {
  xAFunction = SIN;
  xAInput = I_MINUS_K;
  xOperator = MULTIPLICATION;
  xBFunction = SIN;
  xBInput = I_K;
  
  yAFunction = COS;
  yAInput = I_PLUS_K;
  yOperator = MULTIPLICATION;
  yBFunction = COS;
  yBInput = I_K;
  
  kMax = 4;
  stepIncrementValue = 512;
  setStepIncrement(stepIncrementValue);
  stepMaxValue = 16;
  setStepMax(stepMaxValue);
  unitSizeMax = 16;
  unitSizeMultiplier = 12;
  incrementType = SAW;
  kIncrement = PI / (2 << 10);
  
  resetK();
}

private void resetK() {
  K = 0;
  K_COUNTER = 0;
  K_SIGN = 1;
}

private void incrementK() {
  switch (incrementType) {
    case SIN:
      sinIncrement();
      break;
    case SAW:
      sawIncrement();
      break;
  }
}

private void sinIncrement() {
  K_COUNTER += kIncrement;
  K = kMax * sin(K_COUNTER);
}

private void sawIncrement() {
  if (K >= kMax || K <= -kMax)
    K_SIGN = -K_SIGN;
  
  K += (kIncrement * K_SIGN);
}