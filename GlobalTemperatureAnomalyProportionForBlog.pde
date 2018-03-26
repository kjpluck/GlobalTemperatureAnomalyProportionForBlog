
HashMap<String, int[][]> data = new HashMap<String, int[][]>();
void setup()
{
  loadData();
  size(960,540);
}

int month = 1;
int year = 1880;

void draw()
{  
  translate(width/2.0,height/2.0);
  String dataKey = month + " " + year;
  int[][] temperatureGrid = data.get(dataKey);
  
  float step = PI/36.0;
  float halfPi = PI/2.0;
  int latCount = 0;
  int lngCount = 0;
  
  for(float lng = -PI; lng < PI; lng+=step)
  {
    for(float lat = halfPi; lat > -halfPi; lat-=step)
    {
      float temperature = temperatureGrid[latCount][lngCount]/100.0;
      color tempColour = getColour(temperature);
      noStroke();
      fill(tempColour);
      
      
      fill(tempColour);
      float halfStep = step/2.0;
      float s = 345/2.0;
      PVector tl = getKavrayskiyVII(lat + halfStep, lng - halfStep);
      PVector tr = getKavrayskiyVII(lat + halfStep, lng + halfStep);
      PVector bl = getKavrayskiyVII(lat - halfStep, lng - halfStep);
      PVector br = getKavrayskiyVII(lat - halfStep, lng + halfStep);

      quad
      (
        tl.x * s, -tl.y * s, 
        tr.x * s, -tr.y * s, 
        br.x * s, -br.y * s, 
        bl.x * s, -bl.y * s
      );
      
      latCount++;
    }
    latCount = 0;
    lngCount++;
  }
  
  
  month++;
  if(month > 12)
  {
    month = 1;
    year++;
    if(year > 2017)
      exit();
  }
}

color getColour(float temperature)
{
  if (temperature < -90)
    return color(150,150,150);
  color tempColour;
  if(temperature >= 0)
    tempColour = lerpColor(color(255,255,255), color(255,0,0), temperature);
  else
    tempColour = lerpColor(color(255,255,255), color(0,0,255), -temperature);
  return tempColour;
}
 //<>//
PVector getKavrayskiyVII(float lat, float lng)
{
  float x = (3.0 * lng / 2.0) * sqrt((1.0/3.0) - sq(lat / PI));
  return new PVector(x, lat);
}


void loadData()
{
  String[] lines = loadStrings("ncdc-merged-sfc-mntp-tab-delimited.dat");
  String theKey = "ignore";
  int latCount = 0;
  int[][] tempGrid = new int[37][73];
  for (String line : lines) 
  {    
    String[] values = split(line, '\t');
    if(values.length == 3)
    {
      data.put(theKey, tempGrid);
      tempGrid = new int[37][73];
      theKey = values[1] + " " + values[2];
      latCount = 0;
      continue;
    }
    
    for(int lngCount = 1; lngCount <= 72; lngCount++)
    {
      tempGrid[latCount][lngCount - 1] = int(values[lngCount]);
    }
    latCount++;
  }
  
}