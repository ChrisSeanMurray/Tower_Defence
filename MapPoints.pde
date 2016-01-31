class MapPoint extends GameObject
{

  MapPoint()
  {
    super(width * 0.5f, height  * 0.5f, 50);
  }

  MapPoint(String line)
  {
    String[] parts = line.split("\t");

    pos.x = Integer.parseInt(parts[0]);
    pos.y = Integer.parseInt(parts[1]);
    this.radius = 20;
  }

  void update()
  {
  }

  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    noFill();
    stroke(255);
    ellipse(0, 0, radius, radius);
    popMatrix();
  }
}