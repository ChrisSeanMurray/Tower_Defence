class Creep extends GameObject
{
  int life;
  int progress;
  PVector temp;
  Creep()
  {
    super(width * 0.5f, height  * 0.5f, 50);
  }

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
    pushMatrix();
    translate(pos.x, pos.y);
    theta = calT(progress);
    println(theta);
    rotate(theta);
    stroke(125);
    fill(255, 0, 0);
    ellipse(0, 0, radius, radius);
    println(pos.x, pos.y);
    popMatrix();
  }

  void update()
  {
    forward.x = sin(theta);
    forward.y = -cos(theta); 
    pos.add(PVector.mult(forward, speed));
    line(pos.x, pos.y, map.get(1).pos.x, map.get(1).pos.y);
    if (pos.dist(map.get(progress).pos) < 5)
    {
      if (progress <= map.size())
      {
        progress++;
      } else
      {
        gameObjects.remove(this);
      }
    }
  }

  float calT(int place)
  {
    float coords;
    coords = atan2(map.get(place).pos.y - pos.y, map.get(place).pos.x - pos.x);
    coords += HALF_PI;
    if (coords < 0)
    {
      coords = map(coords, -PI, 0, PI, TWO_PI);
    }


    return coords;
  }
}