class Bubble {
  Coordinate r;
  color col;
  boolean leftRow;
  ArrayList<Bubble> colorComplex;

  float vel = UNIT/4;

  float vx;
  float vy;

  boolean stopped;

  Bubble(float x, float y) {
    this.r = new Coordinate(x, y);
    this.randomColor();
    this.determineLeft();

    this.colorComplex = new ArrayList<Bubble>();
    this.colorComplex.add(this);

    this.vx = 0;
    this.vy = 0;

    this.stopped = false;
  }

  void show() {
    ellipseMode(RADIUS);
    noStroke();
    fill(this.col);
    circle(this.r.x, this.r.y, UNIT/2);
  }

  void popInPlace() {
    float currentdis = 5*UNIT;

    float xn = 0;
    float yn = 0;

    for (int j = 0; j < 20; j++) {
      for (int i = 0; i < 17; i++) {
        float x = OFFSET + UNIT/2 + i*(UNIT + GAP);
        if (j%2 != 0) {
          x += UNIT/2;
        }
        float y = OFFSET + UNIT/2 + j*UNIT;
        float dis = dist(this.r.x, this.r.y, x, y);
        if (dis < currentdis) {
          xn = x;
          yn = y;
          currentdis = dis;
        }
      }
    }
    this.r.x = xn;
    this.r.y = yn;
  }

  void stahp() {
    this.vx = 0;
    this.vy = 0;

    this.popInPlace();

    this.stopped = true;
  }

  boolean checkCollision(Bubble b) {
    return(this.r.distance(b.r) <= UNIT);
  }

  void update() {
    this.r.x += this.vx;
    this.r.y += this.vy;

    if (this.r.x <= LX + UNIT/2 || this.r.x >= RX - UNIT/2) {
      this.vx *= -1;
    }

    for (Bubble b : bubbles) {
      if (checkCollision(b)) {
        this.stahp();
      }
    }
  }

  void shoot() {
    float delx = mouseX - this.r.x;
    float dely = mouseY - this.r.y;
    float dis = dist(this.r.x, this.r.y, mouseX, mouseY);
    float vx1 = delx * vel / dis;
    float vy1 = dely * vel / dis;

    this.vx = int(vx1);
    this.vy = int(vy1);
  }

  void randomColor() {
    int i = int(random(COLORS.length));
    this.col = COLORS[i];
  }

  boolean hasCoordinate(Coordinate r) {
    return(r.same(this.r));
  }

  void delete() {
    bubbles.remove(this);
  }

  void listFriends() {
    ArrayList<Bubble> friends = this.addFriends(this.colorComplex);
    for (Bubble n : friends){
      if(!this.colorComplex.contains(n)){
        this.colorComplex.add(n);
      }
    }
  }

  //Expands the colorComplex ArrayList with all the friends!
  ArrayList<Bubble> addFriends(ArrayList<Bubble> currentFriends) {
    ArrayList<Bubble> neigh = this.sameColorNeighbours();
    ArrayList<Bubble> newFriends = currentFriends;
    for (Bubble n : neigh) {
      if (!currentFriends.contains(n)) {
        newFriends.add(n);
        ArrayList<Bubble> moreFriends = n.addFriends(newFriends);
        for (Bubble mf : moreFriends) {
          if (!newFriends.contains(mf)) {
            newFriends.add(mf);
          }
        }
      }
    }
    return newFriends;
  }

  ArrayList<Bubble> sameColorNeighbours() {
    ArrayList<Bubble> ans = new ArrayList<Bubble>();
    for (Bubble b : this.neighbours()) {
      if (b.col == this.col) {
        ans.add(b);
      }
    }
    return ans;
  }

  //returns an ArrayList with all the neighboring bubbles;
  ArrayList<Bubble> neighbours() {
    ArrayList<Bubble> ans = new ArrayList<Bubble>();

    float x1 = this.r.x - UNIT/2;
    float x2 = this.r.x + UNIT/2;
    float x3 = this.r.x - UNIT;
    float x4 = this.r.x + UNIT;

    float y1 = this.r.y - UNIT;
    float y2 = this.r.y;
    float y3 = this.r.y + UNIT;

    Coordinate[] co = {new Coordinate(x1, y1), new Coordinate(x2, y1), new Coordinate(x3, y2), new Coordinate(x4, y2), new Coordinate(x1, y3), new Coordinate(x2, y3)};

    for (Bubble b : bubbles) {
      for (Coordinate c : co) {
        if (b.hasCoordinate(c)) {
          ans.add(b);
        }
      }
    }    
    return ans;
  }

  void murder() {
    if (this.colorComplex.size() > 2) { 
      for (Bubble b : this.colorComplex) {
        b.delete();
      }
    }
  }

  void determineLeft() {
    float y1 = (this.r.y - OFFSET - UNIT/2)/UNIT;
    leftRow = (y1%2 == 0);
  }
}
