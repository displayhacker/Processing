import controlP5.*;

ControlP5 cp5;
Slider abc;
float rotationValue = 0;
float rotationIncrement = 0;
float offset = 0;
float offsetIncrement = 0.01;
PGraphics buffer;
PGraphics copy;

void setup() {
  //frameRate(1);
  size(1024, 768);
  noStroke();
  cp5 = new ControlP5(this);
  cp5
    .addSlider("rotationIncrement")
    .setPosition(16, 752)
    .setRange(-0.1, 0.1)
    .setValue(0.02)
    .setHandleSize(4)
    .setSliderMode(Slider.FLEXIBLE)
  ;
  buffer = createGraphics(1024, 768);
  buffer.beginDraw();
  buffer.line(256, 256, 512, 512);
  buffer.line(512, 512, 768, 256);
  buffer.endDraw();
  copy = createGraphics(1024, 768);
  copy.beginDraw();
  copy.background(#FFFFFF);
  copy.endDraw();
}

void updateBuffer() {
  rotationValue += rotationIncrement;
  offset += offsetIncrement;
  float normalizedValue = map(sin(rotationValue), -1, 1, 0, 1);
  float piValue = map(sin(rotationValue), -1, 1, 0, TWO_PI);
  float piValue2 = map(sin(rotationValue + offset), -1, 1, 0, TWO_PI);
  float normalizedByte = map(sin(rotationValue), -1, 1, 0, 255);
  //copy.clear();
  
  copy.beginDraw();
  float copyScale = 0.25 * normalizedValue + 0.5;
  copy.scale(copyScale);
  copy.tint(255, 192, 128, 0.25 * normalizedByte + 64);
  float copyTranslateX = 512 + ((1-normalizedValue) * 512);
  float copyTranslateY = 384 + ((1-normalizedValue) * 384);
  copy.translate(copyTranslateX, copyTranslateY);
  copy.rotate(piValue*1.0);
  copy.image(buffer, -512, -384);
  copy.endDraw();
  
  copy.beginDraw();
  copy.scale(copyScale);
  copy.tint(255, 128, (normalizedByte * 0.5), 240);
  copy.translate(copyTranslateX + 256, copyTranslateY + 192);
  copy.rotate(-piValue2*2.0);
  copy.image(buffer, -512, -384);
  copy.endDraw();
  
  buffer.clear();
  buffer.beginDraw();
  buffer.tint(255, 255, 255, 255);
  buffer.image(copy, 0, 0);
  buffer.endDraw();
}

void draw() {
  updateBuffer();
  background(#FFFFFF);
  image(buffer, 0, 0);
}
