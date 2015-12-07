class DrawPlanets
{
  boolean showdata = false;
  boolean moveufo = false;
  float rotz;
  float ufox = 1000;
  float ufoy = 600;
  float s = 1;
  int planetno = 0;
  DrawPlanets()
  {
  }

  void update()
  {
    if (keyPressed)
    {
      if (key == ENTER)
      {
        pressed = true;
      }
      if (key == ' ' && pressed == true)
      {
        moveufo = true;
      }
    }//end if keypressed

    if (moveplanet == 1)
    {
      rotz += TWO_PI/9;
      planetno--;
      if (planetno < 0)
      {
        planetno = 8;
      }
      moveplanet = 0;
    }
    
    if (moveplanet == 2)
        {
          rotz -= TWO_PI/9;
          planetno++;
          if (planetno > 8)
          {
            planetno = 0;
          }
          moveplanet = 0;
        }

    if (moveufo == true)
    {
      ufox -= 5;
      ufoy -= 7;
      s+= 0.07;

      if (ufox < width/2)
      {
        ufox = width/2;
      }
      if (ufoy < height/5)
      {
        ufoy = height/5;
      }

      if (ufox == width/2 && ufoy == height/5)
      {
        s = 6;
        showdata = true;
      }
    }//end if
  }//end update
  void render()
  {
    background(galaxy);
    frameRate(30);
    sphereDetail(30);
    noStroke();
    lights();

    pushMatrix();
    translate(ufox, ufoy);
    scale(s);
    shape(ufo);
    popMatrix();

    if (pressed == false)
    {
      translate(width/2, height/2);
      rotateX(1.3);
    } else
    {
      if (showdata == true)
      {
        fill(255);
        textAlign(CENTER);
        text("Planet Name: " + planetname[planetno], width/2, height/3);
        text("Planet Diameter: " + planetsize[planetno] + " km", width/2, height/3 + 20);
        text("Distance from Sun: " + sundistance[planetno] + " million km", width/2, height/3 + 40);
        text("Orbital Period: " + revolution[planetno] + " days", width/2, height/3 + 60);
      }
      translate(width/2, height/1.7);
      rotateX(1.5);
    }

    fill(255, 180, 0);
    pushMatrix();
    sun = createShape(SPHERE, 100); 
    shape(sun);
    popMatrix();

    fill(255);

    if (pressed == false)
    {
      for (int i = 0; i < planets.size (); i++)
      {
        pushMatrix();
        rotateZ(PI * frameCount/revolution[i]);
        translate(sundistance[i], 0);
        ball[i] = createShape(SPHERE, planetsize[i]);
        ball[i].setTexture(planetimg[i]);
        rotateX(1.5);
        shape(ball[i]);
        popMatrix();
        rotate(TWO_PI/planets.size());
      }//end for
    } else
    {
      rotateZ(1.58);
      rotateZ(rotz);
      for (int i = 0; i < planets.size (); i++)
      {
        pushMatrix();
        translate(300, 0);
        ball[i] = createShape(SPHERE, 50);
        ball[i].setTexture(planetimg[i]);
        rotateX(1.2);
        shape(ball[i]);
        popMatrix();
        rotate(TWO_PI/planets.size());
      }//end for
    }//end else
  }//end render
}//end class