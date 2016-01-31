class Tower extends GameObject
{
  float range;
  int elapsed;
  Tower()
  {
    super(width * 0.5f, height  * 0.5f, 50);
  }

  Tower(float x, float y, int radius, float range )
  {
    pos.x = x;
    pos.y = y;
    this.radius = radius;
    this.range = range;
    elapsed = 0;
  }

  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    noFill();
    stroke(0, 255, 0);
    line(- radius, radius, 0, - radius);
    line(0, - radius, radius, radius);
    line(radius, radius, 0, 0);
    line(- radius, radius, 0, 0);
    ellipse(0, 0, range, range);
    if (elapsed > 10)
    {
      fire();
      elapsed = 0;
    }
    elapsed++;

    popMatrix();
  }

  void update()
  {
    for (int i = creeps.size() - 1; i >= 0; i --)
    {
      Creep go = creeps.get(i);

      if (go.pos.dist(pos) < range/2)
      {
        theta = atan2(go.pos.y - pos.y, go.pos.x - pos.x);

        //need to add half_pi because of how atan2 calculates 0 - PI, it is off sync with standard 0 -PI
        theta += HALF_PI;

        //maps the results of atan2 to remove negative pi values
        if (theta < 0)
        {
          theta = map(theta, -PI, 0, PI, TWO_PI);
        }
      }
    }
  }

  void fire()
  {
    Projectile pro = new Projectile(pos.x, pos.y, theta, 1, 2, 5, range);
    pro.pos.add(PVector.mult(forward, 10));
    gameObjects.add(pro);
  }
}