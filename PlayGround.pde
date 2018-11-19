class PlayGround extends PGraphics {
  PVector location;
  int width;
  int height;
JSONObject jsonCityIO;
  ArrayList<Grid> grids;
  PVector gridSize;
  int _index;
  String _url;
 PlayGround() {
  this(new PVector(0,0),0,0,"default",0);
 }
  PlayGround(PVector l, int w, int h,String link,int index) {
    _index=index;
    width=w;
     jsonCityIO=loadJSONObject(link);


    height=h;
    grids = new ArrayList();
    _url=link;
        println("new playground #"+_index+": url="+_url);
        println("position [x/y]:"+l.x+":"+l.y);
location=new PVector();
    location.set(l.x,l.y);
    grids.add(new Grid(location, 16, 16, 20));
  }

  void display(PGraphics p) {
    if (isGridHasChanged) {
         jsonCityIO = loadJSONObject(_url);

        println("display "+this+"#"+_index+": url="+_url);
        println("position [x/y]:"+location.x+":"+location.y);
      updateGridJSON();
      isGridHasChanged = false;
    }

    p.fill(255);  
    p.textSize(10);
    p.text("PlayGround"+_index, location.x-width/2, location.y-height*0.52);
    for (Grid g : grids) {
      g.display(p);
    }
  }

  PVector getGridSize() {
    return new PVector(16, 16);
  }
  
  void updateGridJSON() {
    int y=-1; 
    JSONArray gridsA = jsonCityIO.getJSONArray("grid");
     // println("gridsA.size()"+gridsA.size());
   
    for (int i=0; i < gridsA.size(); i++) {
      //if the first value in gridsA is a JSONobject,
      //its a "grid":[{"data":{"solar":1389,"traffic":0,"wait":0},"rot":0,"type":-1,"x":0,"y":0} json type
      if ((gridsA.get(0) instanceof JSONObject)) { 
        JSONObject grid =  gridsA.getJSONObject(i);
        int rot = grid.getInt("rot");
        int type = grid.getInt("type");
        int x = grid.getInt("x");
        y = grid.getInt("y");
        grids.get(0).addBlock(new PVector(15-x, y), 20, type);
      } 
      //else if gridsA is a JSONarray full of int,
      //its a "grid":[-1,0,0,0,0,0,0,0,0,0,0,0] json style
      else if ((gridsA.get(0) instanceof Integer)) {
        int x=i%16;
        if (x==0) {
          y++;
        }     
        //unused: int rot = grid.getInt("rot");
        int type = gridsA.getInt(i);
        grids.get(0).addBlock(new PVector(15-x, y), 20, type);
      }
      //else, this json is a mess
      else {
        println ("JSon parsing failed");
      }
    }
  }
}
