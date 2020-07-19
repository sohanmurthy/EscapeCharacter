//Connects to local Fadecandy server and maps P3LX points to physical pixels
//TODO: Simplify output function

FadecandyOutput buildOutput() {
  FadecandyOutput output = null;
  int[] pointIndices = buildPoints();
  output = new FadecandyOutput(lx, "192.168.1.136", 7890, pointIndices);
  lx.addOutput(output);
  output.setDithering(true);
  return output;
}

//Function that maps point indices to pixels on led strips
int[] buildPoints() {
  int pointIndices[] = new int[model.size];
  int i = 0;
  for (int pixels = 0; pixels < model.size; pixels = pixels + 1) {
          pointIndices[i] = pixels;
      i++;
  }
  return pointIndices; 
}
