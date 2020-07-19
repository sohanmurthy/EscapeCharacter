// Defines the model with a few parameters for strip size/pixel density and orientation
// 0.65625 inches between pixels = 60 LEDs per meter
// 1.325 inches between pixels = 30 LEDs per meter

public static final int   STRIP_PIXELS = 60;
public static final float PIXEL_SPACING = 1.325;
public static final float STRIP_SPACING = 22;
public static final float STRIP_OFFSET = 6;

static class Model extends LXModel {

  Model() {
    super(new Fixture());
  }

  private static class Fixture extends LXAbstractFixture {

    Fixture() {
      
      addPoints(new PixelStrip(0,  0,  82));
      addPoints(new PixelStrip(STRIP_SPACING,  0,  98));
      
      addPoints(new PixelStrip(STRIP_SPACING + STRIP_OFFSET,  0,  82));
      addPoints(new PixelStrip((STRIP_SPACING*2) + STRIP_OFFSET,  0,  98));
      
      addPoints(new PixelStrip((STRIP_SPACING*2) + (STRIP_OFFSET*2),  0,  82));
      addPoints(new PixelStrip((STRIP_SPACING*3) + (STRIP_OFFSET*2),  0,  98));

      
    }
    
  }
  
}


//Define a strip and its angle in two dimensions
static class PixelStrip extends LXAbstractFixture {

  private PixelStrip(float xP, float yP, float theta) {
    for (int i = 0; i < STRIP_PIXELS; ++i) {
      addPoint(
        new LXPoint(xP+i*(PIXEL_SPACING*cos(radians(theta))), yP+i*(PIXEL_SPACING*sin(radians(theta)))
        )
      );
    }
  }
}
