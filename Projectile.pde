class Projectile extends GameObject
{

  Projectile()
  {
    speed = 20.0f;
    radius = 5;
  }

  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    ellipse(0, 0, radius, radius);
    popMatrix();
  }

  void update()
  {
    forward.x = sin(theta);
    forward.y = - cos(theta);

    forward.mult(speed);
    pos.add(forward);

    if (pos.x < 0 || pos.y < 0 || pos.x > width || pos.y > height)
    {
      // Im dead!
      gameObjects.remove(this);
    }

    
  }
}