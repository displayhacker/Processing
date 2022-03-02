PImage stareCatImage;
PGraphics bufferA;
PGraphics bufferB;
int canvasWidth = 1024;
int canvasHeight = 768;
int imageWidth = 512;
int imageHeight = 512;
float rotationValue = -0.5;
float rotationIncrement = 0.025;
float offset = 0;
float offsetIncrement = 0.1;
float scaleFactorA = 0.5;
float baseScaleFactorB = 2;
float scaleFactorB = sqrt(baseScaleFactorB) * scaleFactorA;
//float scaleFactorB = (0.5 * (sqrt(5) + 1)) - 1;


float bufferAX = canvasWidth - imageWidth * 0.5;
float bufferAY = 2 * canvasHeight - imageHeight;
float bufferATranslateX = 0;
float bufferATranslateY = 0;

int ax = -1;
int ay = 1;
int ar = 1;
int bx = -1;
int by = 1;
int br = -1;

void keyPressed() {
  switch (key) {
    case '1':
      ax = incrementInteger(ax, -1, 1);
      break;
    case '2':
      ay = incrementInteger(ay, -1, 1);
      break;
    case '3':
      ar = incrementInteger(ar, -1, 1);
      break;
    case '4':
      bx = incrementInteger(bx, -1, 1);
      break;
    case '5':
      by = incrementInteger(by, -1, 1);
      break;
    case '6':
      br = incrementInteger(br, -1, 1);
      break;
  }
  print("ax:"+ax+"; ay:"+ay+"; ar:"+ar+"; bx:"+bx+"; by:"+by+"; br:"+br+";scaleFactorA:"+scaleFactorA+";\n");
}

float incrementFloat(float input, float min, float max, float amount) {
  input += amount;
  if (input > max) {
    input = min;
  }
  return input;
}

int incrementInteger(int input, int min, int max) {
  input++;
  if (input > max) {
    input = min;
  }
  return input;
}

void setup() {
  frameRate(60);
  size(1024, 768, P2D);
  background(#000000);
  stareCatImage = loadImage("mao.jpg");
  bufferA = createGraphics(canvasWidth, canvasHeight, P2D);
  bufferA.beginDraw();
  bufferA.scale(scaleFactorA);
  bufferA.image(stareCatImage, bufferAX, bufferAY);
  bufferA.endDraw();
  
  bufferB = createGraphics(canvasWidth, canvasHeight, P2D);
  bufferB.beginDraw();
  bufferB.image(bufferA, 0, 0);
  bufferB.endDraw();
}

void draw() {
  rotationValue += rotationIncrement;
  
  float rotationSin = sin(rotationValue);
  
  float rotationSizeOffset = map(rotationSin, -1, 1, -256, 256);
  
  background(128);
  
  bufferA.beginDraw();
  bufferA.clear();
  
  bufferA.pushMatrix();
  bufferA.tint(255, 192, 192, 254);
  bufferA.scale(scaleFactorB);
  bufferA.translate(1033 + rotationSizeOffset * ax, 596 + rotationSizeOffset * ay);
  bufferA.rotate(rotationValue * ar);
  bufferA.image(bufferB, -512, -640);
  bufferA.popMatrix();
  
  bufferA.pushMatrix();
  bufferA.scale(scaleFactorA);
  bufferA.tint(192, 255, 192, 254);
  bufferA.translate(-bufferATranslateX, -bufferATranslateY);
  bufferA.image(stareCatImage, bufferAX, bufferAY);
  bufferA.popMatrix();
  
  
  bufferA.pushMatrix();
  bufferA.tint(192, 192, 255, 255);
  bufferA.scale(scaleFactorB);
  bufferA.translate(415 - rotationSizeOffset * bx, 596 + rotationSizeOffset * by);
  bufferA.rotate(rotationValue * br);
  bufferA.image(bufferB, -512, -640);
  bufferA.popMatrix();
  
  bufferA.endDraw();
  
  
  
  bufferB.beginDraw();
  bufferB.clear();
  bufferB.tint(255, 255, 255, 255);
  bufferB.image(bufferA, 0, 0);
  bufferB.endDraw();
  
  image(bufferB, 0, 0);
}
