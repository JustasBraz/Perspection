import processing.dxf.*;
import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;  

PeasyCam cam;

boolean record;
boolean controlZoom=false;
boolean orbit = false;
boolean recordEnt=false;

PImage[] pictures= new PImage[722];
ArrayList<IntList> picArray = new ArrayList<IntList>();

int val=0;
int step=0;
int weight=1;
int threshold=-200;
int index=0;
int counter=0;
int tempVal=997;

float rotation =90;
float zoom=0;

void setup() {
  size(1500, 800, P3D);
  cam = new PeasyCam(this, 550);
  for (int i=0; i<pictures.length; i++) {
    if (i<=8) {
      pictures[i]=loadImage("thumb000"+(i+1)+".png");
    }

    if (i>=9&&i<=98) {
      // println("thumb00"+(i+1)+".png");
      pictures[i]=loadImage("thumb00"+(i+1)+".png");
    }

    if (i>=99) {
      //println("thumb0"+(i+1)+".png");
      pictures[i]=loadImage("thumb0"+(i+1)+".png");
    }
  }

  //-----------------------//
  //make an array of arrays//
  //-----------------------//

  int dimension = pictures[0].width * pictures[0].height;
  for (int i=0; i<pictures.length; i++) {
    IntList points1 = new IntList();

    IntList points2 = new IntList();
    pictures[i].loadPixels();
    // IntList points1 = new IntList();
    for (int u = 0; u < dimension; u += 1) { 


      points1.append(int(map(pictures[i].pixels[u], -16777216, -1, 200, 0))); 
      points2.append(pictures[i].pixels[u]);
    }

    picArray.add(points1);
    picArray.add(points2);

    pictures[i].updatePixels();
  }

  println("Entering Draw");
}

void draw() {
  background(255);
  if (orbit) {
    float orbitRadius= 550-zoom;//mouseX/2+100;
    float ypos= 0;//mouseY/3;
    float xpos= cos(radians(rotation))*orbitRadius;
    float zpos= sin(radians(rotation))*orbitRadius;

    camera(xpos, ypos, zpos, 0, 0, 0, 0, 1, 0);

    if (zoom>=0&&zoom<150&&!controlZoom) {
      zoom+=1;
      if (zoom>148) {
        controlZoom=true;
      }
    } else if (zoom>1&&controlZoom) {
      zoom-=1;
    }
    println(zoom);

    rotation++;
  }
  if (record) {
    beginRaw(DXF, "pointCloud"+tempVal+".dxf");
  }

  int i=0;
  lights();
  pushMatrix();
  rotate(PI/2);

  for (int x=-pictures[0].height/2; x<pictures[0].height/2; x+=1) {
    for (int y=-pictures[0].width/2; y<pictures[0].width/2; y+=1) {

      stroke(picArray.get(index+1).get(i));

      point(x, y, picArray.get(index).get(i));

      counter++;

      strokeWeight(weight);
      if (i<picArray.get(index).size()) {
        i++;
      }
    }
  }

  popMatrix();
  if (index+2<picArray.size()) {
    index+=2;
  }


  if (recordEnt) {
    saveFrame("entrance"+frameCount+".png");
  }
  if (keyPressed) {
    if (key == 'b' || key == 'B') {
      step-=100;
    }
    if (key == 'e' || key == 'E') {
      index+=2;
      i=0;
      println("index is "+index);
    }
    if (key == 'r' || key == 'R') {
      if (index>0) {
        index-=2;
        i=0;
        println("index is "+index);
      }
    }
    if (key == 'g' || key == 'G') {
      if (tempVal>1) {
        tempVal-=1;
      }
    }

    if (key == 'j' || key == 'J') {
      recordEnt=true;
    }

    if (key == 'o' || key == 'O') {
      orbit=true;
    }
  }
  if (record) {
    endRaw();
    record = false;
  }
}
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      threshold+=5;
    } else if (keyCode == DOWN) {
      threshold-=5;
    } else if (keyCode == LEFT) {
      weight-=1;
      println(weight);
    } else if (keyCode == RIGHT) {
      weight+=1;
      println(weight);
    }
  } else if (key == 't') {
    record = true;
  }
}