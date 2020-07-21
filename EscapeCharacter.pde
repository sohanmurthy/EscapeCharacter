/********************************************************

  ESCAPE CHARACTER

  ESCAPE CHARACTER is an LED art installation located
  in a private residence in Oakland, CA.

 *********************************************************/

final static int INCHES = 1;
final static int FEET = 12*INCHES;
final static int SECONDS = 1000;
final static int MINUTES = 60*SECONDS;

Model model;
P3LX lx;
LXOutput output;
UI3dComponent pointCloud;

void setup() {

  model = new Model();
  lx = new P3LX(this, model);

  lx.setPatterns(new LXPattern[] {
    
    new Horizon(lx),
    new Spirals(lx),
    new ColorSwatches(lx, 6),
    
    //new BaseHuePattern(lx),
    //new IteratorTestPattern(lx),

    });


  final LXTransition multiply = new MultiplyTransition(lx).setDuration(22*SECONDS);

  for (LXPattern p : lx.getPatterns()) {
    p.setTransition(multiply);
  }

  lx.enableAutoTransition(120*MINUTES);

  output = buildOutput();

  // Adds UI elements -- COMMENT all of this out if running on Linux in a headless environment
  size(800, 600, P3D);
  lx.ui.addLayer(
    new UI3dContext(lx.ui)
    .setCenter(model.cx, model.cy, model.cz)
    .setRadius(12*FEET)
    .setRadiusBounds(3*FEET, 20*FEET)
    .addComponent(pointCloud = new UIPointCloud(lx, model).setPointSize(8))
    );

  lx.ui.addLayer(new UIChannelControl(lx.ui, lx, 0, 0));
  lx.ui.addLayer(new UIOutput(lx.ui, width - 144, 4));

}


void draw() {
  background(#191919);
}
