float[][] x = new float[3][3];
float[] cof = new float[20];
float l1, l2, L1, L2;
float u, f1, f2;
float dt;

float G1,G2;

float[][] RK1 = new float[2][3];
float[][] RK2 = new float[2][3];
float[][] RK3 = new float[2][3];
float[][] RK4 = new float[2][3];

void setup() {
  size(800, 450);

  dt = 0.1;

  cof[0] = 0.2;
  cof[1] = 0.4;
  cof[2] = 0.2;
  cof[3] = 0.2;
  cof[4] = 0.4;
  cof[5] = 0.8;
  cof[6] = 0.2;
  cof[7] = 0.6;
  cof[8] = 0.1;
  cof[9] = 0.8;

  L1 = 80;
  L2 = 80;

  x[0][0] =width/100;
  x[1][0] = 0;

  x[0][1] = 0;
  x[1][1] = 0;

  x[0][2] = 0;
  x[1][2] = 0.001;
}
void draw() {
  if (mousePressed == true) {
    if (mouseButton == RIGHT)
      f1 = -0.5;
    if (mouseButton == LEFT)
      f2 = 0.5;
  }
  if (keyPressed == true) {
    if (keyCode == RIGHT) {
      u = 0.5;
    }
    if (keyCode == LEFT) {
      u = -0.5;
    }
  }
  println(f1 + ", " + f2);

  x[2][0] = -cof[0]*x[1][0] + u;
  x[2][1] = -cof[1]*x[2][0]*cos(x[0][1]) - cof[5]*x[2][2]*cos(x[0][1]-x[0][2]) - cof[3]*sq(x[1][1])*sin(x[0][1]-x[0][2]) + cof[4]*sin(x[0][1]) - cof[8]*x[1][1];
  x[2][2] = -cof[5]*x[2][1]*cos(x[0][1]-x[0][2]) - cof[6]*sq(x[1][2])*sin(x[0][1]-x[0][2]) + cof[7]*sin(x[0][1]-x[0][2]) - cof[9]*x[1][2] + f1 + f2;
  G1 = abs(500*f1);
  G2 = abs(500*f2);
  u = 0;
  f1 = 0;
  f2 = 0;

  /*
   x[][] left bracket is differential order, right bracket is variable.
   x[][0] = x
   x[][1] = theta1
   x[][2] = theta2
   */

  for (int j=2; j>=0; j--) { //variable type
    for (int i=1; i>=0; i--) { //differential order
      //Runge-Kutta method
      RK1[i][j] =  x[i+1][j] *dt;
      RK2[i][j] = (x[i+1][j] + RK1[i][j]/2)*dt;
      RK3[i][j] = (x[i+1][j] + RK2[i][j]/2)*dt;
      RK4[i][j] = (x[i+1][j] + RK3[i][j])*dt;
      x[i][j] += (RK1[i][j] + 2*RK2[i][j] + 2*RK3[i][j] + RK4[i][j])/6;
    }
  }

  //draw
  int scale = 50;
  int rodLen = 80;
  int ribLen = 20;
  int CenterHight = height/3;
  background(200);
  noFill();
  strokeWeight(3);
  rectMode(CENTER);
  rect(scale*x[0][0], CenterHight, scale, scale); //cart
  strokeWeight(8);
  point(scale*x[0][0], CenterHight); //cart joint
  strokeWeight(20);
  point(scale*x[0][0] - rodLen*cos(x[0][1] + PI/2), CenterHight - rodLen*sin(x[0][1] + PI/2)); //pendulum weight1
  point(scale*x[0][0] - rodLen*cos(x[0][1] + PI/2) - rodLen*cos(x[0][2] + PI/2), CenterHight - rodLen*sin(x[0][1] + PI/2) - rodLen*sin(x[0][2] + PI/2)); //pendulum weight2
  strokeWeight(5);
  line(scale*x[0][0], CenterHight, scale*x[0][0] - rodLen*cos(x[0][1] + PI/2), CenterHight - rodLen*sin(x[0][1] + PI/2)); //pendulum rod1
  line(scale*x[0][0] - rodLen*cos(x[0][1] + PI/2), CenterHight - rodLen*sin(x[0][1] + PI/2),
    scale*x[0][0] - rodLen*cos(x[0][1] + PI/2) - rodLen*cos(x[0][2] + PI/2), CenterHight - rodLen*sin(x[0][1] + PI/2) - rodLen*sin(x[0][2] + PI/2)); //pendulum rod2
  line(scale*x[0][0]+ribLen*cos(-x[0][1]), CenterHight-ribLen*sin(-x[0][1]), scale*x[0][0]-ribLen*cos(-x[0][1]), CenterHight + ribLen*sin(-x[0][1]));//pendulum rib1
  //line(scale*x[0][0]+ribLen*cos(-x[0][2])- rodLen*cos(x[0][1] + PI/2), height/2-ribLen*sin(-x[0][2])- rodLen*sin(x[0][1] + PI/2),
  //      scale*x[0][0]-ribLen*cos(-x[0][2])- rodLen*cos(x[0][1] + PI/2), height/2 + ribLen*sin(-x[0][2])- rodLen*sin(x[0][1] + PI/2));//pendulum rib2
  stroke(255, G1, 0);
  line(scale*x[0][0]-ribLen*cos(-x[0][1]), CenterHight + ribLen*sin(-x[0][1]), scale*x[0][0]+ribLen*sin(x[0][2])- rodLen*cos(x[0][1] + PI/2), CenterHight - ribLen*cos(x[0][2])- rodLen*sin(x[0][1] + PI/2));//muscle1
  stroke(255, G2, 0);
  line(scale*x[0][0]+ribLen*cos(-x[0][1]), CenterHight-ribLen*sin(-x[0][1]), scale*x[0][0]+ribLen*sin(x[0][2])- rodLen*cos(x[0][1] + PI/2), CenterHight-ribLen*cos(x[0][2])- rodLen*sin(x[0][1] + PI/2));//muscle2
  
  
  stroke(0);
  strokeWeight(2);
  int n = 5;
  for (int k = 0; k<n; k++) {
    line(50*x[0][0], CenterHight - 6*2*k, 50*x[0][0], CenterHight - 6*(2*k-1));
  }

  fill(255);
  textSize(20);
  //text("Runge-Kutta", width/2, height/2-100);
}
