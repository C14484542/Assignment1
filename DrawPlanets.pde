class DrawPlanets
{
  boolean enterpressed = false;
  boolean spacepressed = false;
  boolean planetmoveok = true;
  boolean moveufo = false;

  float ufox = 1200;
  float ufoy = 700;
  float s = 1;
  float astroy = 250;
  float liney = 250;

  int prot = 0; //direction of rotation of planets
  float rotateZ = 0; //keep the planets rotating  
  float frame = 0; //frame count to keep planets rotating until the planet in the middle
  float rot = 0; //change from 1 planet to another and stops planets from rotating
  int count = 0;
  DrawPlanets()
  {
  }

  void update()
  {
    if (keyPressed)
    {
      if (key == ENTER)
      {
        enterpressed = true;
      }
      if (key == ' ' && enterpressed == true)
      {
        moveufo = true;
      }

      if (planetmoveok == true)
      {
        if (key == CODED)
        {
          if (keyCode == RIGHT)
          {
            prot = 1;
          }
          if (keyCode == LEFT)
          {
            prot = 2;
          }
        }//end if keyCoded
      }//end if planetmoveok
    }//end if keypressed


    if (prot == 1)
    {
      if (frame < 55.0f)
      {
        count = 0;
        frame+=1.0f; 
        rotateZ = (rot + TWO_PI * frame/500);
        planetmoveok = false;
      }
      if (frame == 55.0f)
      {
        count = 1;
        prot = 0;
        frame = 0;
        rot += TWO_PI / 9;
        planetno--;
        planetmoveok = true;
        if (planetno < 0)
        {
          planetno = 8;
        }
      }
    }

    if (prot == 2)
    {
      if (frame < 55.0f)
      {
        count = 0;
        frame+=1.0f; 
        rotateZ = (rot - TWO_PI * frame/500);
        planetmoveok = false;
      }
      if (frame == 55.0f)
      {
        count = 1;
        prot = 0;
        frame = 0;
        rot -= TWO_PI / 9;
        planetno++;
        if (planetno > 8)
        {
          planetno = 0;
        }
        planetmoveok = true;
      }
    }//end if prot == 2

    if (moveufo == true && planetmoveok == true)
    {
      ufox -= 7;
      ufoy -= 9;
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
        s = 7;
        spacepressed = true;
        astroy+=4;
        if (astroy > height/1.3)
        {
          option = 5;
          astroy = 250;
          moveufo = false;
          enterpressed = false;
        } else
        {
          option = 1;
        }

        liney+=4;
        if (liney > height/1.3)
        {
          liney = height/1.3;
        }
      }
    }//end if
    else
    {
      ufox = 1200;
      ufoy = 700;
      s = 1;
      astroy = 250;
      liney = 250;
    }
  }//end update
  void render()
  {
    background(galaxy);
    frameRate(30);
    sphereDetail(30);
    lights();

    fill(255);
    textSize(15);
    textAlign(RIGHT);
    text("Press backspace to go back to main menu", width, 20);

    pushMatrix();
    translate(ufox, ufoy);
    scale(s);
    shape(ufo);
    popMatrix();

    if (spacepressed == true && ufox == width/2 && ufoy == height/5)
    {
      pushMatrix();
      translate(width/2, astroy);
      rotate(PI);
      rotateY(PI * frameCount/100);
      scale(20);
      astro.disableStyle();
      shape(astro);
      popMatrix();

      for (float i = width/3; i < width - width/3; i++)
      {
        stroke(255, 255, 255, 30);
        line(width/2, height/3.5, i, liney);
      }
    } 

    noStroke();
    if (enterpressed == false)
    {
      pushMatrix();
      textAlign(CENTER);
      fill(255,0,0);
      textSize(20);
      text("Press ENTER to navigate through planets",width/2,height/10);
      popMatrix();
      translate(width/2, height/2);
      rotateX(1.4);
    } else
    {
      pushMatrix();
      textAlign(CENTER);
      fill(255,0,0);
      textSize(20);
      text("Press left and right arrow keys to navigate through planets",width/2,height/10);
      text("Press spacebar to bring astronaut to that planet and show data",width/2, height/10+30);
      popMatrix();
      translate(width/2, height/1.7);
      rotateX(1.5);
    }


    if (enterpressed == false)
    {
      pushMatrix();
      fill(255, 180, 0);
      sun = createShape(SPHERE, 100); 
      shape(sun);
      popMatrix();
      for (int i = 0; i < planets.size (); i++)
      {
        pushMatrix();
        fill(255);
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
      fill(255);
      rotateZ(1.58);
      //if count == 0 then keep rotating 
      if (count == 0)
      {
        rotateZ(rotateZ);
      }
      //if count == 1 then stop rotating
      else if (count == 1)
      {
        rotateZ(rot);
      }
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