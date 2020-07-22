/******************
Color Swatches
*******************/

class ColorSwatches extends LXPattern{
  
  ColorSwatches(LX lx, int num_sec){
   super(lx);
   //size of each swatch in pixels
    final int section = num_sec;
   for(int s = 0; s <= model.size-section; s+=section){
     if((s+section) % (section*2) == 0){
     addLayer(new Swatch(lx, s, s+section, 28));
     }else{
       addLayer(new Swatch(lx, s, s+section, 0));
     }
   }
  }

  public void run(double deltaMs) {
    setColors(#000000);
  }

  class Swatch extends LXLayer {

    private final SinLFO sync = new SinLFO(6*SECONDS, 10*SECONDS, 49*SECONDS);
    private final SinLFO bright = new SinLFO(20,100, sync);
    private final SinLFO sat = new SinLFO(45,65, sync);
    private final TriangleLFO hueValue = new TriangleLFO(0, 44, sync);
    private final TriangleLFO hueOsc = new TriangleLFO(190, 340, 3.37*MINUTES);

    private int sPixel;
    private int fPixel;
    private float hOffset;

    Swatch(LX lx, int s, int f, float o){
      super(lx);
      sPixel = s;
      fPixel = f;
      hOffset = o;
      addModulator(sync.randomBasis()).start();
      addModulator(bright.randomBasis()).start();
      addModulator(sat.randomBasis()).start();
      addModulator(hueValue.randomBasis()).start();
      addModulator(hueOsc.randomBasis()).start();
    }

    public void run(double deltaMs) {
      float s = sat.getValuef();
      float b = constrain(bright.getValuef(), 0, 100);

      for(int i = sPixel; i < fPixel; i++){
        blendColor(i, LXColor.hsb(
          hueOsc.getValuef() + hueValue.getValuef() + hOffset,
          s,
          b
          ), LXColor.Blend.LIGHTEST);
        }
    }

  }

}


/******************
Spirals
*******************/

class Spirals extends LXPattern {
    
  Spirals(LX lx) {
    super(lx);
    for (int i = 0; i < 12; ++i) {
      addLayer(new Wave(lx, i*6));
    }
  }

  public void run(double deltaMs) {
    setColors(#000000);
    lx.cycleBaseHue(9.67*MINUTES);
  }
  
  class Wave extends LXLayer {
    
    final private SinLFO rate1 = new SinLFO(200000*2, 290000*2, 17000);
    final private SinLFO off1 = new SinLFO(-4*TWO_PI, 4*TWO_PI, rate1);
    final private SinLFO wth1 = new SinLFO(7, 12, 30000);

    final private SinLFO rate2 = new SinLFO(228000*1.6, 310000*1.6, 22000);
    final private SinLFO off2 = new SinLFO(-4*TWO_PI, 4*TWO_PI, rate2);
    final private SinLFO wth2 = new SinLFO(15, 20, 44000);

    final private SinLFO rate3 = new SinLFO(160000, 289000, 14000);
    final private SinLFO off3 = new SinLFO(-2*TWO_PI, 2*TWO_PI, rate3);
    final private SinLFO wth3 = new SinLFO(12, 140, 40000);

    final private float hOffset;
    
    Wave(LX lx, float o) {
      super(lx);
      hOffset = o;
      addModulator(rate1.randomBasis()).start();
      addModulator(rate2.randomBasis()).start();
      addModulator(rate3.randomBasis()).start();
      addModulator(off1.randomBasis()).start();
      addModulator(off2.randomBasis()).start();
      addModulator(off3.randomBasis()).start();
      addModulator(wth1.randomBasis()).start();
      addModulator(wth2.randomBasis()).start();
      addModulator(wth3.randomBasis()).start();
    }

    public void run(double deltaMs) {
      for (LXPoint p : model.points) {
        
        float vy1 = model.yRange/4 * sin(off1.getValuef() + (p.x - model.cx) / wth1.getValuef());
        float vy2 = model.yRange/4 * sin(off2.getValuef() + (p.x - model.cx) / wth2.getValuef());
        float vy = model.ay + vy1 + vy2;
        
        float thickness = 11 + 6 * sin(off3.getValuef() + (p.x - model.cx) / wth3.getValuef());
        float ts = thickness/1.4;

        blendColor(p.index, LXColor.hsb(
        (lx.getBaseHuef() + hOffset + (p.x / model.xRange) * 160) % 360,
        min(100, (100/ts)*abs(p.y - vy)), 
        max(0, 40 - (40/thickness)*abs(p.y - vy))
        ), LXColor.Blend.ADD);
      }
    }
   
  }

}

/******************
Horizon
*******************/

class Horizon extends LXPattern {
   
  Horizon(LX lx) {
    super(lx);
    for (int i = 0; i < 12; ++i) {
      addLayer(new HorizonLine(lx, i*14));
    }
    
  }
  
  public void run(double deltaMs) {
    setColors(#000000);
  }
  
  
  class HorizonLine extends LXLayer {
    
    final private Click posChange = new Click(random(15*SECONDS, 45*SECONDS));
    final private QuadraticEnvelope yPos = new QuadraticEnvelope(random(model.yMin, model.yMax),0,0).setEase(QuadraticEnvelope.Ease.BOTH);
    final private SinLFO interval = new SinLFO(15*SECONDS, 45*SECONDS, 4*MINUTES);
    final private SinLFO thickness = new SinLFO(13, 8, interval);
    final private TriangleLFO hueOsc = new TriangleLFO(255, 290, 5*MINUTES);
    final private float hOffset;
    
    private void init() {
      yPos.setRangeFromHereTo(random(model.yMin, model.yMax)).setPeriod(random(20*SECONDS, 35*SECONDS)).start();
    }

    
    HorizonLine(LX lx, float o){
      super(lx);
      addModulator(posChange).start();
      addModulator(yPos);
      addModulator(interval.randomBasis()).start();
      addModulator(thickness.randomBasis()).start();
      addModulator(hueOsc.randomBasis()).start();
      hOffset = o;
    }
    
     public void run(double deltaMs) {
      
      if (posChange.click()) {
        init();
      } 
       
      for (LXPoint p : model.points) {
        
        float b = 100 - 100 * abs(p.y - yPos.getValuef())/model.yRange * thickness.getValuef();
        float s = 100;
        if (b > 0) {
            blendColor(p.index,
                       LXColor.hsb(
                                   hueOsc.getValuef() + hOffset,
                                   s,
                                   b
                                   ),
                       LXColor.Blend.LIGHTEST
                       );
        }
        
      }
    }
    
  }
  
  
}
