
String videoPrefix = "0"; // Edit to the prefix your extracted images share, like "IMG_420"
int totalFrames = 36; // Edit this to how many frames you're working with
PImage videoFrame;

String drawingPrefix = "rtshp-";
PImage drawing;

// Color selector
PImage selector;
PImage folderEmpty;
int sx = 1288;
int sy = 6;
color scolor;

int currentFrame = 1;
boolean showVideo = true;

PGraphics d;  // Drawing layer

int brushWeight= 3; // For '[' and ']' toggle of brush weight

// Undo function
PGraphics tempD;
boolean undoPressed = false;
int num =20;

void setup() {

  size (1320, 820);  // Window size has to account for colorpicker bar
  d = createGraphics(1280, 720); // Output image size (renders at 100%)
  tempD = createGraphics(1280, 720);
  loadFrame();
  loadDrawing();
  
  // Color selector
  selector = loadImage("colors.png");
  scolor = color(0, 0, 0);
  background(255, 255, 255);
  
  // Error message images
  folderEmpty = loadImage("folderempty.png");

}


void draw() {
  background(40);
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
  
  // User controls legend
  text("> = previous frame", 20, 750);
  text("< = next frame", 20, 770);
  text("spacebar = hide  source frame", 20, 800);
  text("z = undo", 150, 750);
  text("r = redo", 150, 770);
  text("[ = smaller brush size", 230, 750);
  text("] = larger brush size", 230, 770);
  
  text("CURRENT FRAME: "+currentFrame, 400, 750);  
}

// User controls
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
      if (currentFrame < 1) {
        currentFrame = totalFrames - 1;
      }
      loadFrame();
      loadDrawing();
    } else if (keyCode == RIGHT) {  // Right arrow key
      saveAnimationFrame();
      currentFrame++;
      if (currentFrame >= totalFrames) {
        currentFrame = 1;
      }
      loadFrame();
      loadDrawing();
    }
  }
}

// Color selector 
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
  
  d.save("output/" + drawingPrefix + nf(currentFrame, 4) + ".png");

  // Clear the drawing layers
  d.beginDraw();
  d.clear();
  d.endDraw();
  tempD.beginDraw();
  tempD.clear();
  tempD.endDraw();
}

void loadFrame() {
  String filename = "input/" + videoPrefix + nf(currentFrame, 2) + ".png";
  videoFrame = loadImage(filename);
  println(currentFrame + " / " + (totalFrames-1));
}



void loadDrawing() {
  try {
    String filename = drawingPrefix + nf(currentFrame, 4) + ".png";
    drawing = loadImage("output/" + filename);
    d.beginDraw();
    d.image(drawing, 0, 0, 1280, 720);
    d.endDraw();
  } 
  catch (Exception e) {
    println("Computer is grumpy!' " + e);
  }
}

void undo() {
  tempD.clear();
}


// Bugs to fix:
// Generate output pngs on run, preventing initial console error
// Automatically figure out int totalFrames so users don't need to edit too much code
// Oh no! I think my undo function is a lot more intense than it should be.

// Features to add:
// Add error message about empty input folder


// if (there is nothing that ends in ".png" in the data folder) {
// image(folderEmpty, x, y);
// text("Hey! Looks like you haven't placed any images in the "input" folder.", x, y, x2, y2);
// } else
// void loadDrawing probably. hmm, this doesn't consider edge cases.

// Add error message / info button with ffmpeg instructions
// ffmpeg -i example.mov -r 12 $example%03d.png
