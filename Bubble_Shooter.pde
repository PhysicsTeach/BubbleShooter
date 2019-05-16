import java.util.Random;

float UNIT = 40;
float OFFSET = 100;
float GAP = 5;

float LX = OFFSET - GAP;
float RX = LX + 17*(UNIT + GAP) + UNIT/2 + GAP;
float UY = LX;
float BY = UY + 15*UNIT;

color RED = color(255, 0, 0);
color GREEN = color(0, 255, 0);
color BLUE = color(0, 0, 255);
color PURPLE = color(255, 0, 255);
color YELLOW = color(255, 255, 0);
color LIGHT = color(0, 255, 255);

color[] COLORS = {RED, GREEN, BLUE, PURPLE, YELLOW, LIGHT};

Bubble active;

ArrayList<Bubble> bubbles;
ArrayList<Bubble> deletionlist;

Arrow arrow;

void setup() {
  size(1000, 1000);
  active = new Bubble(OFFSET + UNIT/2 + 8*(UNIT + GAP), OFFSET + UNIT/2 + 20*UNIT);
  bubbles = new ArrayList<Bubble>();
  deletionlist = new ArrayList<Bubble>();
  startBubbles();
  arrow = new Arrow(active.r.x, active.r.y, mouseX, mouseY, RED);
}

void draw() {
  background(100, 100, 50);
  active.show();
  for (Bubble b : bubbles) {
    if (b.neighbours().size() == 0) {
      deletionlist.add(b);
    }
    b.show();
  }
  active.update();
  if (active.stopped) {
    active.listFriends();
    bubbles.add(active);
    active.murder();
    newActive();
  }
  stroke(0);
  line(LX, UY, RX, UY);
  line(LX, UY, LX, BY);
  line(RX, BY, LX, BY);
  line(RX, BY, RX, UY);
  
  arrow.updatexe(mouseX);
  arrow.updateye(mouseY);
  arrow.show();
  
  
  for(Bubble b : deletionlist){
    b.delete();
  }
}

void mouseClicked() {
  if (active.vy == 0) {
    active.shoot();
  }
}

void newActive() {
  active = new Bubble(OFFSET + UNIT/2 + 8*(UNIT + GAP), OFFSET + UNIT/2 + 20*UNIT);
}

//returns a random Bubble from the list bubbles. Mostly for debugging.
Bubble getRandomBubble() {
  Random rand = new Random();
  return(bubbles.get(rand.nextInt(bubbles.size())));
}

void startBubbles() {
  for (int j = 0; j < 9; j++) {
    for (int i = 0; i < 17; i++) {
      float x = OFFSET + UNIT/2 + i*(UNIT + GAP);
      if (j%2 != 0) {
        x += UNIT/2;
      }
      float y = OFFSET + UNIT/2 + j*UNIT;
      bubbles.add(new Bubble(x, y));
    }
  }
}
