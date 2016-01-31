class Tower extends GameObject
{
  float range;
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
    popMatrix();
  }

  void update()
  {
    for (int i = gameObjects.size() - 1; i >= 0; i --)
    {
      GameObject go = gameObjects.get(i);
      if (go instanceof Creep)
      {
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
          
          Projectile pro = new Projectile();
          pro.pos.x = pos.x;
          pro.pos.y = pos.y;
          pro.pos.add(PVector.mult(forward, radius));
          pro.theta = theta;
          gameObjects.add(pro);
          
        }
      }
    }
  }
}