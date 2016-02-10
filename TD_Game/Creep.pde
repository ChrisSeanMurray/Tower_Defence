class Creep extends GameObject
{
  int life;
  int progress;

  //non-parameterised constructor
  Creep()
  {
    super(width * 0.5f, height  * 0.5f, 50);
  }

  //parameterised constructor
  Creep(float x, float y, float speed, int life, int radius)
  {
    pos.x = x;
    pos.y = y;
    this.speed = speed;
    this.radius = radius;
    this.life = life;
    progress = 0;
  }

  void render()
  {
    float x1, x2, y1, y2;
    pushMatrix();
    translate(pos.x, pos.y);

    //calling the calT method to calculated the approriate angle to rotate to
    theta = calT(progress);
    rotate(theta);
    stroke(c);
    fill(c);
    
    //calculting coordinates for drawing creeps, and drawing creeps
    ellipse(0, 0, radius/5, radius);
    x1 = radius * cos(QUARTER_PI*3);
    y1 = radius * sin(QUARTER_PI*3);
    x2 = radius * cos((HALF_PI*3)*0.95);
    y2 = radius * sin((HALF_PI*3)*0.95);
    line(x1, y1, x2, y2);
    x1 = radius * cos(QUARTER_PI);
    y1 = radius * sin(QUARTER_PI);
    x2 = radius * cos((HALF_PI*3)*1.05);
    y2 = radius * sin((HALF_PI*3)*1.05);
    line(x1, y1, x2, y2);
    x1 = radius * cos(QUARTER_PI*3);
    y1 = radius * sin(QUARTER_PI*3);
    x2 = radius * cos(HALF_PI *1.1);
    y2 = radius * sin(HALF_PI*1.1);
    line(x1, y1, x2, y2);
    x1 = radius * cos(QUARTER_PI);
    y1 = radius * sin(QUARTER_PI);
    x2 = radius * cos(HALF_PI*0.9);
    y2 = radius * sin(HALF_PI*0.9);
    line(x1, y1, x2, y2);
    x1 = radius * cos((HALF_PI*3)*0.95);
    y1 = radius * sin((HALF_PI*3)*0.95);
    x2 = radius * cos(HALF_PI *1.1);
    y2 = radius * sin(HALF_PI*1.1);
    line(x1, y1, x2, y2);
    x1 = radius * cos(HALF_PI*0.9);
    y1 = radius * sin(HALF_PI*0.9);
    x2 = radius * cos((HALF_PI*3)*1.05);
    y2 = radius * sin((HALF_PI*3)*1.05);
    line(x1, y1, x2, y2);

    popMatrix();
  }

  void update()
  {
    //adjusts the color of the crep depending on how much health it has
    if (life ==1)
    {
      c = #FC0303;
    } else if (life ==2)
    {
      c = #1A58D8;
    } else if (life == 3)
    {
      c = #E88C02;
    } else
    {
      c = #86EA05;
    }


    forward.x = sin(theta);
    forward.y = -cos(theta); 
    pos.add(PVector.mult(forward, speed));

    //if the creep gets close to the point it is moving towards it's new destination is
    //calculated as the next point and is pointed towards it
    if (pos.dist(map.get(progress).pos) < 2)
    {
      if (progress < map.size() - 1)
      {
        progress++;
      } else
      {
        //if the crep reaches the end of the map it dies
        gameObjects.remove(this);
      }
    }
    if (life <= 0)
    {
      if (popSound != null)
      {
        popSound.rewind();
        popSound.play();
      }
      gameObjects.remove(this);
      creeps.remove(this);
    }
  }


  //Mapping method to determine what direction the creeps should be moving by calculating
  //the angle of the next point in the map
  float calT(int place)
  {
    float coords;
    coords = atan2(map.get(place).pos.y - pos.y, map.get(place).pos.x - pos.x);

    //need to add half_pi because of how atan2 calculates 0 - PI, it is off sync with standard 0 -PI
    coords += HALF_PI;

    //maps the results of atan2 to remove negative pi values
    if (coords < 0)
    {
      coords = map(coords, -PI, 0, PI, TWO_PI);
    }
    return coords;
  }
}