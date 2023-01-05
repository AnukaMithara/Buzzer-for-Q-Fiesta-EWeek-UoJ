const int numButtons = 3; // number of buttons
const int buttonPins[] = {2, 3, 13}; // pins for the buttons   //13 for reset

void setup() {
  Serial.begin(9600); // start serial communication at 9600 baud
  for (int i = 0; i < numButtons; i++) {
    pinMode(buttonPins[i], INPUT_PULLUP); // set the button pins as inputs with pull-up resistors
  }
}

void loop() {
  for (int i = 0; i < numButtons; i++) {
    int buttonState = digitalRead(buttonPins[i]); // read the state of the button
    Serial.write(i | (buttonState << 4)); // send the button number and state over serial
  }
  delay(10); // delay for 10 milliseconds
}
