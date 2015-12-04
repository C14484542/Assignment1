ArrayList<Planets> planets = new ArrayList<Planets>();

//images and shapes
PImage galaxy;
PShape sun, ufo;
String[] pimage = new String[9];
PImage[] planetimg = new PImage[9];
PShape[] ball = new PShape[9];
float[] planetsize = new float[9];
float[] sundistance = new float[9];
float[] revolution = new float[9];
float[] sortd = new float[9];

float minrev, maxrev;
float highestd, lowestd, avgd; 

float a = 0;

void setup()
{
  size(1200, 700, P3D);
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

    //planetsize[i] = map(planets.get(i).diameter, lowestd, highestd, 5, 50);
    sundistance[i] = map(planets.get(i).sun_distance, planets.get(0).sun_distance, planets.get(8).sun_distance, 200, 5000);
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
  println(maxrev);
  println(minrev);
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
  }
}

void draw()
{
  background(galaxy);
  frameRate(30);
  sphereDetail(30);
  noStroke();
  lights();
  fill(255, 180, 0);
  translate(width/2, height/3);
  pushMatrix();
  sun = createShape(SPHERE, 100); 
  shape(sun);
  popMatrix();

  pushMatrix();
  translate(250, 350);


  shape(ufo, 50, 50);
  popMatrix();


  fill(255);

  rotateX(1.3);

  for (int i = 0; i < planets.size (); i++)
  {
    pushMatrix();
    rotateZ(PI * frameCount/revolution[i]);
    translate(sundistance[i], 0);
    ball[i] = createShape(SPHERE, planetsize[i]);
    ball[i].setTexture(planetimg[i]);
    rotateX(1.2);
    shape(ball[i]);
    popMatrix();
    rotate(TWO_PI/planets.size());
  }
  a++;
}