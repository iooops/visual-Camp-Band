
import ddf.minim.*;
import ddf.minim.analysis.*;
FFT fft;
float val;
int val2;
int bufferSize = 8;
int fftSize = floor(bufferSize * .9) + 1;

int angle = 0;

int walk;

AudioPlayer player;
Minim minim;

PShape group;
PShape eyelw, eyerw;

void setup() {
  size(1280, 720, P2D);
  minim = new Minim(this);
  player = minim.loadFile("complete-TURKEY.wav");
  player.loop();
  fft = new FFT(player.bufferSize(), player.sampleRate());
  
  eyelw = createShape(ELLIPSE, -10, 0, 10, 10);
  eyelw.setFill(color(255));
  eyelw.endShape();
  
  eyerw = createShape(ELLIPSE, 20, 0, 10, 10);
  eyerw.setFill(color(255));
  eyerw.endShape();
  
  group = createShape(GROUP);
  
  PShape eyel = createShape(ELLIPSE, -25, 0, 50, 50);
  eyel.setFill(color(0));
  PShape eyer = createShape(ELLIPSE, 25, 0, 50, 50);
  eyer.setFill(color(0));
  
  // Make a path PShape
  PShape path = createShape();
  path.beginShape();
  path.noFill();
  path.stroke(0);
  for (float a = -PI; a < 0; a += 0.1) {
    float r = random(60, 70);
    path.vertex(r*cos(a), r*sin(a));
  }
  path.endShape();
  
  PShape path2 = createShape();
  path2.beginShape();
  // Set fill and stroke
  path2.noFill();
  path2.stroke(0);
  path2.strokeWeight(2);
  
  float x = -80;
  // Calculate the path as a sine wave
  for (float a = 0; a < PI; a+=0.1) {
    path2.vertex(x,sin(a)*100);
    x+= 5;
  }
  // The path is complete
  path2.endShape();  
  
  // Add them all to the group
  group.addChild(eyel);
  group.addChild(eyer);
  group.addChild(path);
  group.addChild(path2);
}


void draw() {
  background(255);
  
  fft.forward(player.mix);
  
  stroke(3, 182, 250);
  strokeWeight(5);
  float b = 0;
  float angle = (2*PI) / 200;
  int step = player.bufferSize() / 200;
  
  walk += 1;
  for(int i=0; i < player.bufferSize() - step; i+=step) {
    float x = 200 + cos(b) * (1000 * player.mix.get(i) + 150);
    float y = 400 + sin(b) * (1000 * player.mix.get(i) + 150);
    float x2 = 500 + cos(b + angle) * (1000 * player.mix.get(i+step) + 150);
    float y2 = 400 + sin(b + angle) * (1000 * player.mix.get(i+step) + 150);
    line(x + walk,y,x2,y2);
    b += angle;
  }
  
  stroke(252, 252, 97);
  strokeWeight(5);
  float c = 0;
  float angle2 = (2*PI) / 200;
  int step2 = player.bufferSize() / 200;
  for(int i=0; i < player.bufferSize() - step; i+=step) {
    float x = 700 + cos(b) * (1000 * player.mix.get(i) + 150);
    float y = 200 + sin(b) * (1000 * player.mix.get(i) + 150);
    float x2 = 800 + cos(b + angle2) * (1000 * player.mix.get(i+step2) + 150);
    float y2 = 400 + sin(b + angle2) * (1000 * player.mix.get(i+step2) + 150);
    line(x,y,x2,y2);
    b += angle;
  }
  
  
  for(int i = 0; i < fftSize; i++) {
    float band = fft.getBand(i);
    float control, afactor = 10;
    control = band * afactor;
    if(control > 1023)  control = 1023;
    
    val = map(control, 0, 1023, 0, 255);
    val2 = int(val);
    
    print("channel ");
    print(i);
    print(" actual value ");
    print(val2);
    println();
    
    fill(186, 247, 95);
    noStroke();
    ellipse(20 + i * width/8, height- val2 * 2, 20, 20);
    
    // flower
    angle += 5;
    float val3 = cos(radians(angle)) * 12.0;
    for (int a = 0; a < 360; a += 75) {
     float xoff = cos(radians(a)) * val3;
     float yoff = sin(radians(a)) * val3;
     fill(250, 71, 220);
     ellipse(5 + i * width/8 + xoff, val2 + yoff, val3, val3);
    }
    fill(250, 71, 220);
    ellipse(5 + i * width/8, val2, 2, 2);
    
    // Display the group PShape
    pushMatrix();
    translate(100, 100);
    shape(group);
    popMatrix();
    
    pushMatrix();
    translate(500, 200);
    shape(group);
    popMatrix();
    
    pushMatrix();
    translate(900, 200);
    shape(group);
    popMatrix();
    
    pushMatrix();
    translate(700, 500);
    shape(group);
    popMatrix();
  }
  fill(0);
  line(0, height - 255, width, height - 255);
  
  stroke(50);
  for(int i = 0; i < player.bufferSize() - 1; i++) {
    pushMatrix();
    translate(100, 100);
    shape(eyelw, player.left.get(i)*50, player.right.get(i)*50, 20, 20);
    popMatrix();
    
    pushMatrix();
    translate(100, 100);
    shape(eyerw, player.right.get(i)*50, player.right.get(i)*50, 20, 20);
    popMatrix();
    
    pushMatrix();
    translate(480, 200);
    shape(eyelw, -player.left.get(i)*50, -player.left.get(i)*50, 20, 20);
    popMatrix();
    
    pushMatrix();
    translate(480, 200);
    shape(eyerw, -player.right.get(i)*50, -player.left.get(i)*50, 20, 20);
    popMatrix();
    
    pushMatrix();
    translate(880, 200);
    shape(eyelw, -player.left.get(i)*50, player.left.get(i)*50, 20, 20);
    popMatrix();
    
    pushMatrix();
    translate(880, 200);
    shape(eyerw, player.right.get(i)*50, 0, 20, 20);
    popMatrix();
    
    pushMatrix();
    translate(690, 490);
    shape(eyelw, player.left.get(i)*50, -player.left.get(i)*100, 20, 20);
    popMatrix();
    
    pushMatrix();
    translate(690, 490);
    shape(eyerw, player.right.get(i)*50, -player.left.get(i)*100, 20, 20);
    popMatrix();
  }
}

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}