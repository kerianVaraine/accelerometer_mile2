import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;

//inits//

Context context;
SensorManager manager;
Sensor sensor;
AccelerometerListener listener;
float ax, ay, az, amag;

int numberOfPoints = 256;
float[][] accelArray = new float[4][numberOfPoints];

//ui interactions for fft Filtering
boolean fftOn = false;
int fftButtX, fftButtY;       // Position of square button
int fftButtSize;              // Button size
// set up logic to turn fft on, with window size changes.
//import fft thing given for assignment.

FFT fft = new FFT(256);


void setup() {
  fullScreen();
 
  context = getActivity();
  manager = (SensorManager)context.getSystemService(Context.SENSOR_SERVICE);
  sensor = manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  listener = new AccelerometerListener();
  manager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_GAME);
 
  textFont(createFont("SansSerif", 30 * displayDensity));
}

void draw() {
  background(0);
  fill(200);
  text("Accelerometer data: \n" +"X: " + ax + "\nY: " + ay + "\nZ: " + az + "\nMag: " + amag , 0, 0, width, height);
           
            // copy everything one value down, make space for new values.
        for (int i=0; i < accelArray[0].length-1; i++) {
          accelArray[0][i] = accelArray[0][i+1];
          accelArray[1][i] = accelArray[1][i+1];
          accelArray[2][i] = accelArray[2][i+1];
          accelArray[3][i] = accelArray[3][i+1];
        }
  //Set values in array
      accelArray[0][accelArray[0].length-1] = ax;
      accelArray[1][accelArray[1].length-1] =ay;
      accelArray[2][accelArray[2].length-1] =az;
      accelArray[3][accelArray[3].length-1] =amag;

        // display all values however you want
        for (int j = 0; j < accelArray.length; j++){
        for (int i=0; i < accelArray[0].length; i++) {
          noStroke();
          //colour sorting by axis/magnitude
          switch(j){
          case(0):
            fill(255,0,0,255);
            break;
            case(1):
            fill(0,255,0);
            break;
            case(2):
            fill(0,0,255);
            break;
            case(3):
            fill(255,255,255);
            break;
          }
          
          //x, y, width, height
          ellipse(width*i / accelArray[j].length + width / numberOfPoints / 2, height / 2 - accelArray[j][i] * 10, width/numberOfPoints, width/numberOfPoints);
      }
        }
 }



//Outside draw and setup Classes

class AccelerometerListener implements SensorEventListener {
  public void onSensorChanged(SensorEvent event) {
    ax = roundDecimal(event.values[0], 4);
    ay = roundDecimal(event.values[1], 4);
    az = roundDecimal(event.values[2], 4);
    amag = roundDecimal(calcMag(ax,ay,az), 4);
  }
  
  public void onAccuracyChanged(Sensor sensor, int accuracy) {}
  
  public float calcMag (float x, float y, float z){
   return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
  }
  
  public float roundDecimal (float n, float r){
    return round((n * (pow(10,r))))/pow(10,r); 
  }
  
}
