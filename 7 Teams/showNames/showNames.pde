import processing.serial.*; // import the serial library
import processing.sound.*;

Serial myPort; // create a Serial object
SinOsc sine;

int[] buttonState = new int[6]; // array to store the state of the buttons
long[][] duration = new long[6][2]; // array to store the time duration              2 - duration   0- button name 3- pressed time
String[] schools = {"BT/ST. MICHAEL'S COLLEGE", "V/VAVUNIYA TAMIL MADHYA MAHA VIDYALAYAM", "T/R.K.M. SRI KONESWARA HINDU COLLEGE", "MU/PUTHUKKUDIYIRUPPU CENTRAL COLLEGE",
"KN/ VADDAKACHI CENTRAL COLLEGE", "MN/ SIDTHI VINAYAGAR HINDU COLLEGE"};
String schName;

long startTime; // variable to store the start time

long qTimeMin = 3; // variable to store the start time
long qTimeSec = 0; // variable to store the start time

long qTime = ((qTimeMin * 60) + qTimeSec) * 1000; // variable to store the start time

PImage img1,img2;

int b = 0;

void setup() {
    //set the size of the window
    size(1760, 990, P3D);
    surface.setTitle("QFiest");
    surface.setResizable(true);
    pixelDensity(displayDensity());
    smooth();
    
    //list all the available serial ports
    
    //open the serial port at 9600 baud
    myPort = new Serial(this, Serial.list()[0], 9600);
    
    //set all the button states to 0 (not pressed)
    for (int i = 0; i < 6; i++) {
        buttonState[i] = 0;
    }
    // Presssed
    for (int i = 0; i < 6; i++) {
        duration[i][1] = 0;
    }
    //Buttonname
    for (int i = 0; i < 6; i++) {
        duration[i][0] = 0;
    }
    
    startTime = millis(); // store the start time in milliseconds
    
    img1 = loadImage("person.png");
    img2 = loadImage("redperson.png");
    
    sine = new SinOsc(this);
    
    frameRate(1000);
}


void draw() {
    // Get the current time in milliseconds
    long timeT = millis(); 
    long minutesT = qTimeMin;
    long secondsT = qTimeSec;
    long millisecondsT = 0;
    
    if ((timeT - startTime) >= qTime) {
        minutesT = qTimeMin;
        secondsT = qTimeSec;
        millisecondsT = 0;
        background(255, 171, 172); // set the background color to white
        
    } else{
        
        // Calculate the minutes, seconds, and milliseconds
        minutesT = ((timeT - startTime) / 60000) % 60;
        secondsT = ((timeT - startTime) / 1000) % 60;
        millisecondsT = (timeT - startTime) % 1000;
        background(223, 233, 251); // set the background color to white
        
    }
    
    
    //read the serial data from the Arduino
    while(myPort.available() > 0) {
        int inByte = myPort.read(); // read the next byte
        int button = inByte & 0b00001111; // get the button number (lower 4 bits)
        int state = inByte & 0b00010000;// get the button state (5th bit)
        //println(button);
        
        if (button != 6) {
            if ((state == 0) && (buttonState[button] == 0)) {      
                buttonState[button] = 1; // set the button state to 1 (pressed)
                duration[b][0] = button + 1;    
                duration[b][1] = millis(); // store the current time
                b++;
                //println(button);      
            }
            
            if (state == 0) {
                sine.play();
                sine.freq(150);
                delay(10);
            } else{      
                sine.stop();      
            } 
        }
        
        //Reset 
        if ((button == 6) && (state == 0)) {
            fill(200); // set the fill color to light grey
            //set all the button states to 0(notpressed)
            for (int i = 0; i < 6; i++) {
                buttonState[i] = 0;
            }              
            //Presssed
            for (int i = 0; i < 6; i++) {
                duration[i][1] = 0;
            }            
            //Button name
            for (int i = 0; i < 6; i++) {
                duration[i][0] = 0;
            }     
            startTime = millis(); // store the start time inmilliseconds
            
            b = 0;
        }        
    }
    
    // draw the button states and press times
    for (int i = 0; i < 6; i++) {
        // draw a rectangle for the button
        fill(200); // set the fill color to light grey
        
        //Images
        if (buttonState[i] == 1) {
            image(img2,120 + i * 280, 50, 200, 200); 
        } else{      
            image(img1,120 + i * 280, 50, 200, 200); // draw the rectangle
        }
        
        //Numbers
        textSize(60);
        fill(255);
        text(i + 1, 220 + i * 280, 220); // draw the button number
    }
    
    int y = 0;
    for (int i = 0; i < 6; i++) {
        fill(0);
        if (duration[i][0] > 0) {      
            long minutes = (duration[i][1]  - startTime) / 60000;  // Calculate the number of minutes (1 minute = 60000 milliseconds)
            long seconds = ((duration[i][1]  - startTime) % 60000) / 1000;  // Calculatethe number of seconds (1 second = 1000 milliseconds)
            long milliseconds = (duration[i][1]  - startTime) % 1000;  // Calculate the numberof milliseconds
                        
            switch((int)duration[i][0]) {
                case 1:
                    // school 1
                    schName = schools[0];                    
                    break;
                case 2:
                    // school 2
                    schName = schools[1];
                    break;
                case 3:
                    // school 3
                    schName = schools[2];
                    break;
                case 4:
                    // school 4
                    schName = schools[3];
                    break;
                case 5:
                    // school 5
                    schName = schools[4];
                    break;
                case 6:
                    // school 6
                    schName = schools[5];
                    break;
                case 7:
                    // school 7
                    schName = schools[6];
                    break;
                default:
            }
            
            textAlign(LEFT);
            textSize(50);
            text(schName, 300, 450 + y * 100);
            textAlign(RIGHT);
            textSize(60);
            text(minutes + " : " + seconds + " : " + milliseconds, 1750, 450 + y * 100);
            line(260, 470 + y * 100,1800,470 + y * 100);
            y++;
        } 
    }     
    
    fill(0);
    textAlign(CENTER);
    textSize(100);
    text(minutesT + " : " + secondsT + " : " + millisecondsT, 960, 350);
}
