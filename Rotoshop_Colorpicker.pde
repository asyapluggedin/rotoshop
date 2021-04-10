String videoPrefix = "IMG_3341";
int totalFrames = 69;
PImage videoFrame;

String drawingPrefix = "animation-";
PImage drawing;

PImage selector;
int sx = 1288;
int sy = 6;
color scolor;

int currentFrame = 0;
boolean showVideo = true;

PGraphics d;  // Drawing layer

int brushWeight= 3; // For '[' and ']' toggle of brush weight

// Undo function
PGraphics tempD;
boolean undoPressed = false;
int num =20;

void setup() {
 // size(760, 480);
  size(1320, 720);
 // d = createGraphics(720, 480);
  d = createGraphics(1280, 720);
  tempD = createGraphics(1280, 720);
  loadFrame();
  loadDrawing();
  
    // from colorselector

  selector = loadImage("colors.png");
  scolor = color(0, 0, 0);
  background(255, 255, 255);

}


void draw() {
  background(153);
  if (showVideo) {
    //image(videoFrame, 0, 0, 720, 480); 
    image(videoFrame, 0, 0, 1280, 720); 
  }
  tempD.beginDraw();
  tempD.stroke(scolor);
  tempD.strokeWeight(brushWeight);
  if (mousePressed) {
    tempD.line(mouseX, mouseY, pmouseX, pmouseY);
  }
  tempD.endDraw();
//  image(d, 0, 0, 720, 480);
  image(d, 0, 0, 1280, 720);
  image(tempD, 0, 0, 1280, 720);
  
  // Draw the color selector
  image(selector, sx, sy);
  
}

void keyPressed() {
  if (key == ' ' ) {
    showVideo = !showVideo;
  }
   if (key == '[' ) {
    brushWeight--;
  }

   if (key == ']' ) {
    brushWeight++;
  }
  
if (key == 'z') {
    undoPressed = true;
    undo();
  }
  if (key == 'r') {
    undoPressed = false;
    //redo();
  }
  
  if (key == CODED) {
    if (keyCode == LEFT) {  // Left arrow key
      saveAnimationFrame();
      currentFrame--;
      if (currentFrame < 0) {
        currentFrame = totalFrames - 1;
      }
      loadFrame();
      loadDrawing();
    } else if (keyCode == RIGHT) {  // Right arrow key
      saveAnimationFrame();
      currentFrame++;
      if (currentFrame >= totalFrames) {
        currentFrame = 0;
      }
      loadFrame();
      loadDrawing();
    }
  }
}

void mousePressed() {
  if (overSelector()) {
    scolor = selector.get(mouseX-sx, mouseY-sy);
  }
}

boolean overSelector() {
  if (mouseX > sx && mouseX < sx+selector.width && 
      mouseY > sy && mouseY < sy+selector.height) {
    return true;
  } else {
    return false;
  }
}

void saveAnimationFrame() {
  d.beginDraw();
  d.image(tempD.get(), 0, 0);
  d.endDraw();
  
  d.save(drawingPrefix + nf(currentFrame, 4) + ".png");

  // Clear the drawing layers
  d.beginDraw();
  d.clear();
  d.endDraw();
  tempD.beginDraw();
  tempD.clear();
  tempD.endDraw();
}

void loadFrame() {
  String filename = videoPrefix + nf(currentFrame, 2) + ".png";
  videoFrame = loadImage(filename);
  println(currentFrame + " / " + (totalFrames-1));
}

void loadDrawing() {
  try {
    String filename = drawingPrefix + nf(currentFrame, 4) + ".png";
    drawing = loadImage("frames/" + filename);
    d.beginDraw();
   // d.image(drawing, 0, 0, 720, 480);
   d.image(drawing, 0, 0, 1280, 720);
    d.endDraw();
  } 
  catch (Exception e) {
    println("Computer says 'No!' " + e);
  }
}

void undo() {
  tempD.clear();
}
