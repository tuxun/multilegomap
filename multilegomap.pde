import deadpixel.keystone.*; //<>//

public int displayWidth = 1000;
public int displayHeight = 500;
public int playGroundWidth = 500;
public int playGroundHeight = 500;
JSONArray jsonCityIObaseList = new JSONArray();

import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.math.*;

import toxi.processing.*;
String baseListUrl= "https://cityio.media.mit.edu/api/tables/list";

ArrayList<String> baseNamesList = new ArrayList<String>();

//String url= "https://cityio.media.mit.edu/api/table/citymatrix";
String url= "https://cityio.media.mit.edu/api/table/TuxunScopeJS";

PlayGround myPlayGround;

Keystone ks;
CornerPinSurface surface;
boolean isGridHasChanged=true;
ArrayList<PlayGround> myPlayGroundList=new ArrayList<PlayGround>();
Vec3D camOffset = new Vec3D(0, 100, 300);
PGraphics[] offscreen;
void setup() {


  size(displayWidth, displayWidth, P3D);

  translate(width/2, height/2, 0);
  rotateX(mouseY*0.01);
  rotateY(mouseX*0.01);
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(playGroundWidth*3, playGroundHeight*3, 50); 
  jsonCityIObaseList = loadJSONArray(baseListUrl);
  offscreen=new PGraphics[jsonCityIObaseList.size()-1];

  isGridHasChanged = true;   
  Vec3D camOffset = new Vec3D(width/2.0, height/2.0, 300);
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);


  for (int i=0; i<jsonCityIObaseList.size()-1; i++)
  {
    PlayGround pg=new PlayGround(new PVector(playGroundWidth/8*i, playGroundHeight/8*i), playGroundWidth, playGroundWidth, jsonCityIObaseList.getString(i), i);
    myPlayGroundList.add(pg);
    offscreen[i] = createGraphics(displayWidth*2, displayHeight*2, P3D);
  }
}


void draw() {
  background(255);
  if (frameCount % 30 == 0) {
    isGridHasChanged = true;
  }
  println("size:"+jsonCityIObaseList.size());
  for (int i=0; i<jsonCityIObaseList.size()-1; i++)
  {
    offscreen[i].beginDraw();
    myPlayGroundList.get(i).display(offscreen[i]);
    offscreen[i].endDraw();
  }
  if (keyPressed) {
    if (keyCode == UP) {
      //car.accelerate(1);
      camOffset.y-=10;
    }
    if (keyCode == DOWN) {
      camOffset.y+=10;
    }
    if (keyCode == LEFT) {
      camOffset.x-=10;
    }
    if (keyCode == RIGHT) {
      camOffset.x+=10;
    }
  }
}
