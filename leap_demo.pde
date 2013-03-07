import java.util.Iterator;
import com.leapmotion.leap.CircleGesture;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.KeyTapGesture;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.SwipeGesture;
import com.onformative.leap.LeapMotionP5;



SparkSystem system;
LeapMotionP5 leap;
int screenX = 1280;
int screenY = 800;

void setup() {
  size(screenX,screenY, P3D);
  system = new SparkSystem();
  leap = new LeapMotionP5(this);
  noStroke();
}

int num = 0;

void draw() {
  background(0);
  num++;
  for (Finger finger : leap.getFingerList()) {
    PVector fingerPos = leap.getTip(finger);
    fill(255,0,0,50);
    //0 to 1400 -> 0 to 2
    float size = (fingerPos.z)/1600*3+4;
    System.out.println(size);
    ellipse(fingerPos.x*1.5-screenX/4, fingerPos.y*1.5-screenY/4, size*20, size*20);
    if(num%4==0) {
      PVector fingerVel = leap.getVelocity(finger);
      system.addSpark(fingerPos, fingerVel, size);
    }
  }
  system.run();
}

class Spark {
  float damper = 30;
  float green = 0;
  float alpha = 200;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color c = color(255, green, 0);
  float size = 1;
  
  Spark(PVector loc, PVector vel, float s) {
    location = new PVector(1.5*loc.x+random(5)-2.5-screenX/4,
                      1.5*loc.y+random(5)-2.5-screenY/4);
    velocity = new PVector(vel.x/(2*damper)+random(4)-2, 
                        vel.y/damper);
    acceleration = new PVector(0, .3);
    green = random(255);
    lifespan = 100;
    size = 10*s;
  }
  
  void run() {
    update();
    display();
  }
  
  void update() {
    alpha = alpha - 2;
    c = color(255, green, 0, alpha);
    location.add(velocity);
    velocity.add(acceleration);
    lifespan -= 1;
  }
  
  void display() {
    fill(c);
    ellipse(location.x, location.y, size, size);
  }
  
  boolean isDead() {
    return lifespan <= 0.0;
  }
}

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class SparkSystem {
  ArrayList<Spark> sparks;
  SparkSystem() {
    sparks = new ArrayList<Spark>();
  }

  void addSpark(PVector loc, PVector vel, float size) {
    sparks.add(new Spark(loc, vel, size));
  }

  void run() {
    Iterator<Spark> it = sparks.iterator();
    while (it.hasNext()) {
      Spark p = it.next();
      p.run();
      if (p.isDead())
        it.remove(); 
    }
  }
}
public void keyPressed() {
  if (key == 'c') {
    
  }
}
