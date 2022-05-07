
String videoPrefix = "0"; // Edit to the prefix your extracted images share, like "IMG_420"
int totalFrames = 69; // Edit this to how many frames you're working with
PImage videoFrame;

String drawingPrefix = "rtshp-";
PImage drawing;

// This loads the color selector
PImage selector;
PImage folderEmpty;
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

  size(1320, 720);  // Window size has to account for colorpicker bar
  d = createGraphics(1280, 720); // Output size
  tempD = createGraphics(1280, 720);
  loadFrame();
  loadDrawing();
  
  // For color selector
  selector = loadImage("colors.png");
  scolor = color(0, 0, 0);
  background(255, 255, 255);
  
  // For error messages
  folderEmpty = loadImage("folderempty.png");

}


void draw() {
  background(153);
  if (showVideo) {
    image(videoFrame, 0, 0, 1280, 720); 
  }
  tempD.beginDraw();
  tempD.stroke(scolor);
  tempD.strokeWeight(brushWeight);
  if (mousePressed) {
    tempD.line(mouseX, mouseY, pmouseX, pmouseY);
  }
  tempD.endDraw();
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

// Code that makes the color selector work
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
  
  d.save("output/" + drawingPrefix + nf(currentFrame + 1, 4) + ".png");

  // Clear the drawing layers
  d.beginDraw();
  d.clear();
  d.endDraw();
  tempD.beginDraw();
  tempD.clear();
  tempD.endDraw();
}

void loadFrame() {
  String filename = "input/" + videoPrefix + nf(currentFrame + 1, 2) + ".png";
  videoFrame = loadImage(filename);
  println(currentFrame + " / " + (totalFrames-1));
}


// if there is no data in the folder that corresponds
// display message
// folderEmpty
// ffmpeg -i example.mov -r 12 $example%03d.png

    // videoFrame = loadImage(folderEmpty);
  //  image(folderEmpty, 0, 0);


void loadDrawing() {
  try {
    String filename = drawingPrefix + nf(currentFrame + 1, 4) + ".png";
    drawing = loadImage("output/" + filename);
    d.beginDraw();
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


// Bugs to fix:
// Making too many output frames for some reason
// I don't like the console error about missing output files,
// they should just all generate on run 

// Features to add
// Missing file empty message in canvas screen
// Display frame in interface panel
// Add interface panel on top
// for gh: add gitignore to the output and data
