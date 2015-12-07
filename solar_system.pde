ArrayList<Planets> planets = new ArrayList<Planets>();
DrawPlanets drawplanets = new DrawPlanets();

import processing.video.*;

Capture video;

PImage prevFrame;
int blah = 0;
float threshold = 150;
int Mx = 0;
int My = 0;
int ave = 0;

float ballX;
float ballY;
int rsp = 5;

//loadData
PImage galaxy;
PShape sun, ufo;
String[] pimage = new String[9];
String[] planetname = new String[9];
PImage[] planetimg = new PImage[9];
PShape[] ball = new PShape[9];
float[] planetsize = new float[9];
float[] sundistance = new float[9];
float[] revolution = new float[9];
float[] sortd = new float[9];

float minrev, maxrev;
float highestd, lowestd, avgd; 

boolean pressed = false;

float barWidth;
int option = 0;
int moveplanet = 0;
color[] colour = new color[9];

//variables for drawAxis()
float border;
float dataRange; 
float windowRange; //length of the axis line 


void setup()
{
  fullScreen(P3D, SPAN);
  surface.setResizable(true);
  galaxy = loadImage("galaxy.png");
  galaxy.resize(width, height);
  loadData();

  highestd = planets.get(0).diameter;
  lowestd = planets.get(0).diameter;
  minrev = planets.get(0).diameter;
  maxrev = planets.get(0).diameter;

  //insertion sort that sorts the planetsize in ascending order
  for (int i = 1; i < planetsize.length; i++)
  {
    float x = planetsize[i];
    int j = i-1;
    while (j >= 0 && planetsize[j] > x)
    {
      sortd[j+1] = planetsize[j];
      j = j - 1;
    }
    sortd[j+1] = x;
  }

  //calculate the highest revolution and the lowest revolution value
  for (int i = 0; i < planets.size (); i ++)
  {
    if (planets.get(i).revolution > maxrev)
    {
      maxrev = planets.get(i).revolution;
    }

    if (planets.get(i).revolution < minrev)
    {
      minrev = planets.get(i).revolution;
    }

    planetname[i] = planets.get(i).planet;
    sundistance[i] = map(planets.get(i).sun_distance, planets.get(0).sun_distance, planets.get(8).sun_distance, 200, 2000);
    revolution[i] = map(planets.get(i).revolution, minrev, maxrev, 100, 500);
  }

  //mapping planet size
  for (int i = 0; i < 9; i++)
  {
    if (i == 0 || i == 2 || i == 3 || i == 8)
    {
      planetsize[i]=map(planetsize[i], sortd[0], sortd[4], 10, 25);
    } else
    {  
      planetsize[i]=map(planetsize[i], sortd[4], sortd[8], 25, 50);
    }
  }

  ufo = loadShape("UFO.obj");

  video = new Capture(this, 640, 480, 30);
  video.start();
  prevFrame = createImage(video.width, video.height, RGB);
  ballX = width/2;
  ballY = height/2;
}

//loads all data
void loadData()
{
  String[] lines = loadStrings("solarsystem.csv");
  for (int i = 1; i < lines.length; i ++)
  {
    Planets p = new Planets(lines[i]);
    planets.add(p);
  }

  for (int i = 0; i < planets.size (); i++)
  {
    pimage[i] = planets.get(i).planet + ".png";
    planetimg[i] = loadImage(pimage[i], "png");
    planetsize[i] = planets.get(i).diameter;
    colour[i] = planets.get(i).colour;
  }

  //data for drawAxis()
  border = width * 0.08f;
  windowRange = (width - (border*2.0f));
  dataRange = 139822;      
  barWidth =  windowRange / (float) (planets.size());
}

void move()
{
  if (video.available()) {

    prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height); 
    prevFrame.updatePixels();
    video.read();
  }

  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();

  Mx = 0;
  My = 0;
  ave = 0;


  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {

      int loc = x + y*video.width;            
      color current = video.pixels[loc];      
      color previous = prevFrame.pixels[loc]; 


      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);
      float diff = dist(r1, g1, b1, r2, g2, b2);


      if (diff > threshold) { 
        pixels[loc] = video.pixels[loc];
        Mx += x;
        My += y;
        ave++;
      } else {

        pixels[loc] = video.pixels[loc];
      }
    }
  }
  fill(255);
  rect(0, 0, width, height);
  if (ave != 0) { 
    Mx = Mx/ave;
    My = My/ave;
  }
  if (Mx > ballX + rsp/2 && Mx > 50) {
    ballX+= rsp;
  } else if (Mx < ballX - rsp/2 && Mx > 50) {
    ballX-= rsp;
  }
  if (My > ballY + rsp/2 && My > 50) {
    ballY+= rsp;
  } else if (My < ballY - rsp/2 && My > 50) {
    ballY-= rsp;
  }

  updatePixels();
  pushMatrix();
  noStroke();
  lights();
  fill(255, 0, 255);
  ellipse(ballX, ballY, 20, 20);
  popMatrix();
}

void drawAxis(ArrayList<Planets> planets, int horizIntervals, int verticalIntervals, float vertDataRange, float border)
{
  stroke(200, 200, 200);
  // Draw the horizontal axis  
  line(border, height - border, width - border, height - border);

  float windowRange = (width - (border * 2.0f));  
  float tickSize = border * 0.1f;

  for (int i = 0; i <= horizIntervals; i ++)
  {   
    textAlign(CENTER, CENTER);
  } 

  // Draw the vertical axis
  line(border, border, border, height - border);

  for (int i = 0; i <= verticalIntervals; i ++)
  {
    float y = map(i, 0, verticalIntervals, height - border, border);
    line(border - tickSize, y, border, y);
    float hAxisLabel = map(i, 0, verticalIntervals, 0, vertDataRange);

    textAlign(RIGHT, CENTER);  
    fill(255);
    text((int)hAxisLabel, border - (tickSize * 2.0f), y);
  }
}

void drawGraph(ArrayList<Planets> planets)
{
  background(galaxy);
  for (int i = 0; i < planets.size (); i++)
  { 
    drawAxis(planets, 10, 10, dataRange, border);
    float xbar = map(i, 0, planets.size(), border, border + windowRange);
    float ybar = map(planets.get(i).diameter, 0, dataRange, height - border, border);
    stroke(colour[i]);
    fill(colour[i]);
    rect(xbar, height-border, barWidth, -(height-border-ybar));

    //text for graph labels
    textAlign(CENTER);
    fill(250, 0, 0);
    text("Diameter of Planets", width/2, 30);
    text("Planets", width/2, height - 10);
    text("D\ni\na\nm\ne\nt\ne\nr", 10, height/2);

    //text for countries in the bar
    pushMatrix();
    //translate(border + 20 + i * barWidth, height-border);
    textAlign(LEFT);
    fill(colour[i]);
    text(planetname[i], border + 20 + i * barWidth, height-border+20);
    popMatrix();
  }
}



void draw()
{
  move();
  
  println(moveplanet);
  if (ballX < width/2 - 50)
  {
    ballX = width/2;
    moveplanet = 1;
  }
  if(ballX > width/2 + 50)
  {
    ballX = width/2;
    moveplanet = 2;
  }

  if (option == 1)
  {
    drawGraph(planets);
  }
  drawplanets.update();
  drawplanets.render();
}