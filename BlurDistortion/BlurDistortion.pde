public class StareCatImage {
  public PImage image;
  public int index;
  public int size;
  public StareCatImage(PImage image, int index, int size) {
    this.image = image;
    this.index = index;
    this.size = size;
  }
}

float rotation = 0;
float rotationIncrement = 0.005;
int size = 300;
int translateValue = size / 2;
int scaleMin = round(size * 0.375);
int scaleMax = round(size * 0.5);
int pixelCount = size * size;
int scaleIncrement = 1;
int scaleSteps;
int scaleIndex = 0;
boolean scaleSignIsPositive = true;
ArrayList<StareCatImage> scaledStareCatImages = new ArrayList<StareCatImage>();

public void setup() {
  size(300, 300, P2D);
  background(0);
  int i = 0;
  for (int scale = scaleMin; scale <= scaleMax; scale += scaleIncrement) {
    PImage image = loadImage("StareCat.png");
    image.resize(scale, scale);
    StareCatImage stareCatImage = new StareCatImage(image, i++, scale);
    scaledStareCatImages.add(stareCatImage);
  }
  scaleSteps = i - 1;
}

public void draw() {
  loadPixels();
  for (int i = 0; i < pixelCount; ++i) {
    int colorValue = pixels[i] - 0x77;
    if (colorValue >= 0) {
      continue;
    }
    int r = (colorValue & 0xFF0000) >> 16;
    int g = (colorValue & 0x00FF00) >> 8;
    int b = colorValue & 0x0000FF;
    switch ("BRG") {
      case "RGB":
        colorValue = (r << 16) | (g << 8) | b;
        break;
      case "RBG":
        colorValue = (r << 16) | (b << 8) | g;
        break;
      case "BGR":
        colorValue = (b << 16) | (g << 8) | r;
        break;
      case "BRG": // Good
        colorValue = (b << 16) | (r << 8) | g;
        break;
      case "GBR": // Good
        colorValue = (g << 16) | (b << 8) | r;
        break;
      case "GRB":
        colorValue = (g << 16) | (r << 8) | b;
        break;
    }
    pixels[i] = colorValue;
  }
  updatePixels();
  filter(BLUR, 1);
  tint(255, 32);
  translate(translateValue, translateValue);
  rotate(rotation);
  rotation += rotationIncrement;
  StareCatImage scaledImage = scaledStareCatImages.get(scaleIndex);
  int imageOffset = round(0.5 * (size - scaledImage.size)) - translateValue;
  image(scaledImage.image, imageOffset, imageOffset);
  
  if (scaleSignIsPositive) {
    scaleIndex += scaleIncrement;
    if (scaleIndex >= scaleSteps) {
      scaleIndex = scaleSteps;
      scaleSignIsPositive = false;
    }
  } else {
    scaleIndex -= scaleIncrement;
    if (scaleIndex <= 0) {
      scaleIndex = 0;
      scaleSignIsPositive = true;
      println(frameRate);
    }
  }
}
