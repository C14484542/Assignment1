ArrayList<Planets> planets = new ArrayList<Planets>();
DrawPlanets drawplanets = new DrawPlanets();

//libraries
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

//variables for loadData()
PImage galaxy;
PShape menubox, sun, ufo, astro;
String[] pimage = new String[9];
String[] planetname = new String[9];
PImage[] menuimg = new PImage[4];
PImage[] planetimg = new PImage[9];
PShape[] ball = new PShape[9];
float[] planetsize = new float[9];
float[] sundistance = new float[9];
float[] revolution = new float[9];
float[] sortd = new float[9];
float minrev, maxrev;
float highestd, lowestd, avgd; 

//variables for drawGraph()
float barWidth;
color[] colour = new color[9];
float radiusx, radiusy;

//variables for drawAxis()
float border;
float dataRange; 
float windowRange; //length of the axis line 

//variables for showPlanetData
Ellipsoid planet, moon, stars;
int planetno = 0;

int option = 0;

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
    sundistance[i] = map(planets.get(i).sun_distance, planets.get(0).sun_distance, planets.get(8).sun_distance, 200, 5000);
    revolution[i] = map(planets.get(i).revolution, minrev, maxrev, 100, 500);
  }

  //mapping planet size
  for (int i = 0; i < planets.size(); i++)
  {
    if (i == 0 || i == 2 || i == 3 || i == 8)
    {
      planetsize[i]=map(planetsize[i], sortd[0], sortd[4], 10, 25);
    } else
    {  
      planetsize[i]=map(planetsize[i], sortd[4], sortd[8], 25, 50);
    }
  }

  // Create the planet
  planet = new Ellipsoid(this, 16, 16);
  planet.setTexture(pimage[planetno]);
  planet.setRadius(90);
  planet.moveTo(new PVector(0, 0, 0));
  planet.strokeWeight(1.0f);
  planet.stroke(color(255, 255, 0));
  planet.moveTo(20, 40, -80);
  planet.tag = "Planet";
  planet.drawMode(Shape3D.TEXTURE);

  // Create the moon
  moon = new Ellipsoid(this, 15, 15);
  moon.setTexture("moon.jpg");
  moon.drawMode(Shape3D.TEXTURE);
  moon.setRadius(20);
  moon.moveTo(0, 0, 220);
  moon.tag = "Moon";

  // Create the star background
  stars = new Ellipsoid(this, 10, 10);
  stars.setTexture("stars01.jpg", 5, 5);
  stars.drawMode(Shape3D.TEXTURE);
  stars.setRadius(500);

  // Add the moon to the planet this makes 
  // its position relative to the planet's
  planet.addShape(moon);

  radiusx = width/2;
  radiusy = height/2;
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
  barWidth =  windowRange / (float) (planets.size());

  //obj files
  ufo = loadShape("UFO.obj");
  astro = loadShape("Astronaut.obj");

  //menu images
  for (int i = 0; i < menuimg.length; i++)
  {
    menuimg[i] = loadImage(i + ".png");
  }
}

//draws the main menu
void menu()
{
  background(galaxy);
  noStroke();
  fill(255);
  pushMatrix();
  translate(width/10, height/2);
  for (int i = 0; i < menuimg.length; i++)
  {
    pushMatrix();
    translate(width/4 * i, 0);
    rotateY(PI * frameCount/200);
    menubox = createShape(BOX, 100);
    menubox.setTexture(menuimg[i]);
    shape(menubox);
    popMatrix();
  }
  popMatrix();

  fill(255, 0, 0);
  textAlign(CENTER);
  textSize(20);
  text("Welcome to the solar sytem data visualisation\nPlease choose a box to navigate to different graphs", width/2, height/10);
  text("Press ESC to exit", width/2, height/5);

  if ((mouseX > width/10 - 100) && (mouseX < width/10 + 100) && (mouseY >  height/2 - 50) && (mouseY < height/2 + 50))
  {
    fill(255);
    text("Look at the visualised solar system", width/2, height/3);
    if (mousePressed)
    {
      option = 1;
    }
  }

  if ((mouseX > width/10 + width/4 - 100) && (mouseX < width/10 + width/4 + 100) && (mouseY >  height/2 - 50) && (mouseY < height/2 + 50))
  {
    fill(255);
    text("Look at pie chart which shows data of the \nDiameter of the Planets", width/2, height/3);
    if (mousePressed)
    {
      option = 2;
    }
  }

  if ((mouseX > width/10 + (width/4 * 2) - 100) && (mouseX < width/10 + (width/4 * 2) + 100) && (mouseY >  height/2 - 50) && (mouseY < height/2 + 50))
  {
    fill(255);
    text("Look at the line graph which shows the data of the \nDistance from the Sun of the Planets", width/2, height/3);
    if (mousePressed)
    {
      option = 3;
    }
  }

  if ((mouseX > width/10 + (width/4 * 3) - 100) && (mouseX < width/10 + (width/4 * 3) + 100) && (mouseY >  height/2 - 50) && (mouseY < height/2 + 50))
  {
    fill(255);
    text("Look at the bar graph which shows the data of the \nRevolution of Planets around the Sun", width/2, height/3);
    if (mousePressed)
    {
      option = 4;
    }
  }
}
void drawAxis(int horizIntervals, int verticalIntervals, float vertDataRange)
{
  stroke(200, 200, 200);
  // Draw the horizontal axis  
  line(border, height - border, width - border, height - border);

  windowRange = (width - (border * 2.0f));  
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

//method for drawing a pie chart which visualises diameter of planets
void drawPieChart()
{
  background(0);
  // Calculate the sum
  float sum = 0.0f;
  for (float f : planetsize)
  {
    sum += f;
  }

  // Calculate the angle to the mouse
  float toMouseX = mouseX - radiusx;
  float toMouseY = mouseY - radiusy;  
  float angle = atan2(toMouseY, toMouseX);  
  // We have to do this because 
  // atan2 returns negative angles if y > 0 
  if (angle < 0)
  {
    angle = map(angle, -PI, 0, PI, TWO_PI);
  }

  // The last angle
  float last = 0;
  // The cumulative sum of the dataset 
  float cumulative = 0;
  for (int i = 0; i < planetsize.length; i ++)
  {
    cumulative += planetsize[i];
    // Calculate the surrent angle
    float current = map(cumulative, 0, sum, 0, TWO_PI);
    // Draw the pie segment
    stroke(colour[i]);
    fill(colour[i]);

    float rx = radiusx;
    float ry = radiusy;
    // If the mouse angle is inside the pie segment
    if (angle > last && angle < current)
    {
      rx = radiusx * 1.5f;
      ry = radiusy * 1.5f;

      textSize(20);
      textAlign(CENTER);
      text("Diameter of Planets", width/2, 60);
      text("Planet: " + planetname[i], width/2, height - 80);
      text("Diameter: " + planetsize[i] + "km", width/2, height - 60);
    }

    // Draw the arc
    arc(
      radiusx
      , radiusy
      , rx
      , ry
      , last
      , current
      );
    last = current;
  }

  stroke(255);
  line(radiusx, radiusy, mouseX, mouseY);

  fill(255);
  textSize(15);
  textAlign(RIGHT);
  text("Press backspace to go back to main menu", width, 20);
}

//method for drawing a line graph which visualises planets' distance from the sun
void drawLineGraph()
{
  background(0);
  textSize(20);
  fill(255, 0, 0);
  drawAxis(5, 10, 5913);
  for (int i = 1; i < planets.size(); i ++)
  {
    stroke(colour[i-1]);
    fill(colour[i-1]);
    float x1 = map(i-1, 0, planets.size(), border, width - border);
    float x2 = map(i, 0, planets.size(), border, width - border);
    float y1 = map(planets.get(i-1).sun_distance, 0, 5913, height - border, border);
    float y2 = map(planets.get(i).sun_distance, 0, 5913, height - border, border);
    line(x1, y1, x2, y2);
    ellipse(x1, y1, 10, 10);
    textSize(15);
    textAlign(CENTER);
    if (i == planets.size() - 1)
    {
      ellipse(x2, y2, 10, 10);
      if (mouseX > x2 - 5 && mouseX < x2 + 5 && mouseY > y2 - 5 && mouseY < y2 + 5)
      {
        text("Planet: " + planets.get(i).planet, width/2, height/3);
        text("Distance from sun: " + planets.get(i).sun_distance + "million km", width/2, height/3 + 20);
      }
    }
    if (mouseX > x1 - 5 && mouseX < x1 + 5 && mouseY > y1 - 5 && mouseY < y1 + 5)
    {
      text("Planet: " + planets.get(i-1).planet, width/2, height/3);
      text("Distance from sun: " + planets.get(i-1).sun_distance + "million km", width/2, height/3 + 20);
    }
    pushMatrix();
    stroke(255,0,0);
    text("Distance of Planets from the Sun", width/2, 30);
    text("Hover the mouse over the points in the graph to show exact distance", width/2, 50);
    popMatrix();
  }//end for
  fill(255);
  textSize(15);
  textAlign(RIGHT);
  text("Press backspace to go back to main menu", width, 20);
}

//method for drawing a bar graph which visualises planets' revolution around the sun
void drawBarGraph()
{
  background(0);
  for (int i = 0; i < planets.size (); i++)
  { 
    drawAxis(10, 10, 90410.5);
    float xbar = map(i, 0, planets.size(), border, border + windowRange);
    float ybar = map(planets.get(i).revolution, 0, 90410.5, height - border, border);
    stroke(colour[i]);
    fill(colour[i]);
    rect(xbar, height-border, barWidth, -(height-border-ybar));

    //text for graph labels
    textAlign(CENTER);
    fill(250, 0, 0);
    text("Period of Revolution around the Sun", width/2, 30);
    text("Hover the mouse over the bars to show exact number of days of revolution", width/2, 50);
    text("Planets", width/2, height - 10);
    text("N\no.\n\no\nf\n\nD\na\ny\ns", 10, height/2);

    //text for countries in the bar
    pushMatrix();
    textAlign(LEFT);
    fill(colour[i]);
    text(planetname[i], border + 20 + i * barWidth, height-border+20);
    popMatrix();

    fill(255);
    textSize(15);
    textAlign(RIGHT);
    text("Press backspace to go back to main menu", width, 20);

    if (i == 0)
    {
      if (mouseX > xbar && mouseX < xbar + barWidth && mouseY < height - border && mouseY > height-border-10)
      {
        text("Planet name: " + planetname[i], width/2, height/5);
        text("Revolution around the sun : " + planets.get(i).revolution, width/2, height/5 + 20);
      }
    }
    if (mouseX > xbar && mouseX < xbar + barWidth && mouseY < height - border && mouseY > ybar)
    {
      pushMatrix();
      textAlign(CENTER);
      text("Planet name: " + planetname[i], width/2, height/5);
      text("Revolution around the sun : " + planets.get(i).revolution, width/2, height/5 + 20); 
      popMatrix();
    }
  }
}

void showPlanetdata()
{
  background(0);
  pushStyle();
  // Change the rotations before drawing
  planet.rotateBy(0, radians(0.6f), 0);
  moon.rotateBy(radians(0.5f), radians(1.0f), 0);
  stars.rotateBy(0, 0, radians(0.02f));

  pushMatrix();
  camera(0, -190, 350, 0, 0, 0, 0, 1, 0);
  planet.setTexture(pimage[planetno]);
  // Draw the planet (will cause all added shapes
  // to be drawn i.e. the moon)
  planet.draw();

  stars.draw();
  popMatrix();
  popStyle();

  fill(255);
  textSize(15);
  textAlign(CENTER);
  text("Planet Name: " + planetname[planetno], width/2, height/10);
  text("Planet Diameter: " + planetsize[planetno] + " km", width/2, height/10 + 20);
  text("Distance from Sun: " + sundistance[planetno] + " million km", width/2, height/10 + 40);
  text("Orbital Period: " + revolution[planetno] + " days", width/2, height/10 + 60);

  fill(255);
  textSize(10);
  textAlign(RIGHT);
  text("Press backspace to go back to main menu", width, 20);
}

void draw()
{
  background(0);

  if (keyPressed)
  {
    if (key == BACKSPACE)
    {
      option = 0;
    }
  }

  if (option == 0)
  {
    menu();
  }

  if (option == 1)
  {
    drawplanets.update();
    drawplanets.render();
  }

  if (option == 2)
  {
    drawPieChart();
  }

  if (option == 3)
  {
    drawLineGraph();
  }

  if (option == 4)
  {
    drawBarGraph();
  }

  if (option == 5)
  {
    showPlanetdata();
  }
}