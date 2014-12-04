// Displaying a 3D cube using matrix multiplication
// Aron Dennen May 8, 2008
// Updated January 15th, 2011
// Made to actually work August 21st, 2013

// Cube shape vertex array
double [][] box_shape = {
  {-100, -100, 100},
  {100,  -100, 100},
  {100,  100,  100},
  {-100, 100,  100},
  {-100, -100, -100},
  {100,  -100, -100},
  {100,  100,  -100},
  {-100, 100,  -100}
};

// The working matrix array
// Holds the vertices as they are multiplied by each matrix
double [][] tMat = {
  {0,  0,  0},
  {0,  0,  0},
  {0,  0,  0},
  {0,  0,  0},
  {0,  0,  0},
  {0,  0,  0},
  {0,  0,  0},
  {0,  0,  0}
};

float thetaX = 0, thetaY = 0;
float scaleFactor = 1.0;

PFont fontA;

void setup() {
  size (500, 500);
  background(0);
  smooth();
  
  fontA = loadFont("Ziggurat-HTF-Black-32.vlw");
}

void draw() {
  background(0);
  
  if (keyPressed) {
    switch (key) {
      case '=': scaleFactor += 0.05;
        break;
      case '-': scaleFactor -= 0.05;
        break;
    }
  }

  // Fill tMat[] with each matrix multiplied vertex
  for(int i = 0; i < box_shape.length; i++) {
    tMat[i] = box_shape[i]; // Copy the vertices into tMat for multiplying
    tMat[i] = multiplyMatrixScale(tMat[i]);
    tMat[i] = multiplyMatrixY(tMat[i]);
    tMat[i] = multiplyMatrixX(tMat[i]);
    
      //println("{" + tMat[i][0] + ", " + tMat[i][1] + ", " + tMat[i][2] + "}");
  }
  drawCube();
}

void drawCube() {
    colorMode(HSB, 100);
    textFont(fontA, 14);
    int ofs = 250; // Offset to put 0,0 in the middle of the screen instead of upper left
    
    fill(50, 100, 100);
    text("3D Cube by Aron Dennen", 5, 20);
    
    // Cube shape index array
    int [][] linesToDraw =  {
                              {0,1}, {1,2}, {2,3}, {3,0},
                              {0,4}, {1,5}, {2,6}, {3,7},
                              {4,5}, {5,6}, {6,7}, {7,4}
                            };
    
    for (int i = 0; i < linesToDraw.length; i++) {
      stroke(35, 100, ((int)tMat[linesToDraw[i][0]][2] + 200)/4);
      line ((int)tMat[linesToDraw[i][0]][0]+ofs, (int)tMat[linesToDraw[i][0]][1]+ofs,
            (int)tMat[linesToDraw[i][1]][0]+ofs, (int)tMat[linesToDraw[i][1]][1]+ofs);
    }
    
    // Vertex labels
    textFont(fontA, 20);
    fill(87.5, 100, 100);
    text("8", (int)tMat[7][0]+ofs, (int)tMat[7][1]+ofs);
    fill(75, 100, 100);
    text("7", (int)tMat[6][0]+ofs, (int)tMat[6][1]+ofs);
    fill(62.5, 100, 100);
    text("6", (int)tMat[5][0]+ofs, (int)tMat[5][1]+ofs);
    fill(50, 100, 100);
    text("5", (int)tMat[4][0]+ofs, (int)tMat[4][1]+ofs);
    fill(37.5, 100, 100);
    text("4", (int)tMat[3][0]+ofs, (int)tMat[3][1]+ofs);
    fill(25, 100, 100);
    text("3", (int)tMat[2][0]+ofs, (int)tMat[2][1]+ofs);
    fill(12.5, 100, 100);
    text("2", (int)tMat[1][0]+ofs, (int)tMat[1][1]+ofs);
    fill(0, 100, 100);
    text("1", (int)tMat[0][0]+ofs, (int)tMat[0][1]+ofs); 
}

// Y Rotation matrix, thetaX is the rotation angle (global)
// Rotate around Y for screen X axis change
double [] multiplyMatrixY(double [] thisPoint) {
  double [] retVal = {0, 0, 0}; // Init the return array
  double x = thisPoint[0];
  double y = thisPoint[1];
  double z = thisPoint[2];
  
  retVal[0] = (cos(thetaX)*x + 0*y + sin(thetaX)*z);     // x
  retVal[1] = (0*x + 1*y + 0*z);  // y
  retVal[2] = (-sin(thetaX)*x + 0*y + cos(thetaX)*z);  // z
  
  // What was this nonsense for?? idk probably testing
  /*
  if (keyPressed) {
    retVal[0] = (cos(thetaX)*x + 0*y + sin(thetaX)*z);     // x
    retVal[1] = (0*x + -1*y + 0*z);  // y
    retVal[2] = (sin(thetaX)*x + 0*y + -cos(thetaX)*z);  // z
  }*/
  
  return retVal;
}

// X Rotation matrix, thetaY is the rotation angle (global)
// Rotate around X for screen Y axis change
double [] multiplyMatrixX(double [] thisPoint) {
  double [] retVal = {0, 0, 0};
  double x = thisPoint[0];
  double y = thisPoint[1];
  double z = thisPoint[2];
  
  retVal[0] = (1*x + 0*y + 0*z);    // x
  retVal[1] = (0*x + cos(thetaY)*y + -sin(thetaY)*z);              // y
  retVal[2] = (0*x + sin(thetaY)*y + cos(thetaY)*z);   // z
  
  return retVal;
}


// Uniform scale matrix, scaleFactor is the amount (global)
double [] multiplyMatrixScale(double [] thisPoint) {
  double [] retVal = {0, 0, 0};
  double x = thisPoint[0];
  double y = thisPoint[1];
  double z = thisPoint[2];
  
  retVal[0] = (scaleFactor*x + 0*y + 0*z);    // x
  retVal[1] = (0*x + scaleFactor*y + 0*z);              // y
  retVal[2] = (0*x + 0*y + scaleFactor*z);   // z
  
  return retVal;
}

void mouseDragged() {
  thetaX += (mouseX - pmouseX) / 50.0;
  thetaY -= (mouseY - pmouseY) / 50.0;
}
