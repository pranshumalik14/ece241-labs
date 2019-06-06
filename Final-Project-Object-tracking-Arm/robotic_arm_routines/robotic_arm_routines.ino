/*
 * Arm Routines v_2.0
 * Last edit: 23 November 2018
 * - Added support for LED strips to show current state
*/

/*
 * Error Log:
 * For INVALID SIGNAL INPUT, ROUTINE IS SET TO PLACE FOR SOME REASON
 */

#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

// input signal threshold
#define IN_THRESH 600

// routine constants
#define SEARCH 1
#define PLACE 2
#define RESET_POSITION 3
#define STOP 4

// servo constants
#define MIN_PULSE_WIDTH 650
#define MAX_PULSE_WIDTH 2350
#define DEFAULT_PULSE_WIDTH 1500
#define FREQUENCY 50

// motor pin# on PCA9685 servo controller
#define BASE_MOTOR 0
#define TOP_MOTOR 1
#define CUP_MOTOR 4

// motor min and max angles
#define BASE_MIN 10
#define BASE_MAX 170
#define TOP_MIN 0
#define TOP_MAX 180
#define CUP_MIN 180
#define CUP_MAX 0

// delays to achieve desired rotation speeds
#define BASE_DELAY 49
#define CUP_DELAY 10
#define TOP_DELAY 14

// led strip output pins
#define RED_PIN 8
#define GREEN_PIN 9
#define BLUE_PIN 10

// intitialize runtime global variables:

// signal input from FPGA's GPIO
int signal_in[4] = {0, 0, 1, 0}; // start with reset
// starting arm state.
int arm_state[3] = {BASE_MIN, TOP_MIN, CUP_MIN}; // {BASE, TOP, CUP}
// arm routine 
int arm_routine = RESET_POSITION; // start with reset
// signal change flag
bool signal_changed = false; // no change from start

// setup servo motor object
Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();

/* run at first, during setup */
void setup() {
  Serial.begin(9600);
  pwm.begin();
  pwm.setPWMFreq (FREQUENCY);
  pinMode (10, INPUT);
}

/* moves motor to the specified angle */
void moveMotor (int angle, int motor_pin) {
  int pulse_wide, pulse_width;
  
  // convert to pulse width
  pulse_wide = map (angle, 0, 180, MIN_PULSE_WIDTH, MAX_PULSE_WIDTH);
  pulse_width = int (float (pulse_wide)/1000000 * FREQUENCY * 4096);
  
  // control Motor
  pwm.setPWM (motor_pin, 0, pulse_width);
}

/* detects change in input signal */
void signal_in_change () {
  // FPGA's GPIO set A8 = 0 when changing
  // make sure change is of a valid type, eliminate stray spikes 
  if ((analogRead(A8)/IN_THRESH == 0) && (analogRead(A9)/IN_THRESH + analogRead(A10)/
     IN_THRESH + analogRead(A11)/IN_THRESH + analogRead(A12)/IN_THRESH) == 1) {
    
    // see if there is a change detected 
    if (signal_in[0] != (analogRead (A9))/IN_THRESH ||
        signal_in[1] != (analogRead (A10))/IN_THRESH ||
        signal_in[2] != (analogRead (A11))/IN_THRESH ||
        signal_in[3] != (analogRead (A12))/IN_THRESH) {
        
        // set new values
        signal_in[0] = (analogRead (A9))/IN_THRESH;
        signal_in[1] = (analogRead (A10))/IN_THRESH;
        signal_in[2] = (analogRead (A11))/IN_THRESH;
        signal_in[3] = (analogRead (A12))/IN_THRESH;

        Serial.println("NEW SIGNAL REGISTERED");
        signal_changed = true; // input signal changed
    }
  }
  // signal change flag is raised with invalid signal
  else if (analogRead(A8)/IN_THRESH == 0) {
    Serial.println("INVALID ROUTINE REQUESTED");
    signal_changed = true;
  }
  // signal change flag is not raised 
  else if (analogRead(A8)/IN_THRESH == 1) {
    Serial.println("NO CHANGE IN INPUT SIGNAL DETECTED");
    signal_changed = false;
  }
  else { // error
    Serial.println("INVALID SIGNAL CHANGE FLAG STATE");
    signal_changed = false;
  }
}

/* interprets routine from input signal combination */
void set_routine () {

  /*
   * The routines are as follows:
   * signal_in 4:1 = 1 0 0 0 --> SEARCH (1)
   * signal_in 4:1 = 0 1 0 0 --> PLACE (2)
   * signal_in 4:1 = 0 0 1 0 --> RESET_POSITION (3)
   * signal_in 4:1 = 0 0 0 1 --> STOP (4)
   * default: STOP (4)
  */

  if ((signal_in[3] == 1) && (signal_in[2] == 0) &&
     (signal_in[1] == 0) && (signal_in[0] == 0)) {
      // set routine to SEARCH
      Serial.println("ROUTINE SET TO SEARCH");
      arm_routine = SEARCH;
  }

  else if ((signal_in[3] == 0) && (signal_in[2] == 1)
          && (signal_in[1] == 0) && (signal_in[0] == 0)) {
      // set routine to PLACE
      Serial.println("ROUTINE SET TO PLACE");
      arm_routine = PLACE;
  }

  else if ((signal_in[3] == 0) && (signal_in[2] == 0)
          && (signal_in[1] == 1) && (signal_in[0] == 0)) {
      // set routine to RESET_POSITION
      Serial.println("ROUTINE SET TO RESET_POSITION");
      arm_routine = RESET_POSITION;
  }

  else if ((signal_in[3] == 0) && (signal_in[2] == 0)
          && (signal_in[1] == 0) && (signal_in[0] == 1)) {
      // set routine to STOP
      Serial.println("ROUTINE SET TO STOP");
      arm_routine = STOP;
  }
  else { // default case is STOP
      arm_routine = STOP;
      Serial.println ("ARM STOPPED: DEFAULT STATE");
  }
}

/* arm routines */
void do_routine () {
  // implement corresponding actions to the routine
  switch (arm_routine) {
    case SEARCH:
      Serial.println("SEARCH ROUTINE INITIATED");

      // yellow while searching
      analogWrite(RED_PIN, 15);
      analogWrite(GREEN_PIN, 15);
      analogWrite(BLUE_PIN, 0);
      
      // rotate base from current position to BASE_MAX degrees
      for (int angle = arm_state[0]; (angle < BASE_MAX) && 
          (analogRead(A8)/600 == 1); angle++) {
        moveMotor ((arm_state[0]), BASE_MOTOR);
        arm_state[0]++; // update arm_state[0] for base motor
        
        // yellow while searching
        analogWrite(RED_PIN, 15);
        analogWrite(GREEN_PIN, 15);
        analogWrite(BLUE_PIN, 0);
        
        delay(BASE_DELAY);
      }
      // rotate base from BASE_MAX to BASE_MIN degrees
      for (int angle = arm_state[0]; (angle > BASE_MIN) 
          && (analogRead(A8)/600 == 1); angle--) {
        moveMotor ((arm_state[0]), BASE_MOTOR);
        arm_state[0]--; // update arm_state[0] for base motor
        
        // yellow while searching
        analogWrite(RED_PIN, 15);
        analogWrite(GREEN_PIN, 15);
        analogWrite(BLUE_PIN, 0);
        
        delay(BASE_DELAY);
      }
      signal_in_change();
      break;
    
    case PLACE:
      Serial.println("PLACE ROUTINE INITIATED");
      
      // rotate top from 0 to TOP_MAX degrees
      for (int angle = arm_state[1]; angle < TOP_MAX; angle++) {
        moveMotor ((arm_state[1]), TOP_MOTOR);
        arm_state[1]++; // update arm_state[1] for top motor

        // green while placing
        analogWrite(RED_PIN, 0);
        analogWrite(GREEN_PIN, 15);
        analogWrite(BLUE_PIN, 0);
        
        delay(TOP_DELAY);
      }
      
      // rotate cup from CUP_MIN to CUP_MAX degrees
      for (int angle = arm_state[2]; angle > CUP_MAX; angle--) {
        moveMotor ((arm_state[2]), CUP_MOTOR);
        arm_state[2]--; // update arm_state[2] for cup motor

        // green while placing
        analogWrite(RED_PIN, 0);
        analogWrite(GREEN_PIN, 15);
        analogWrite(BLUE_PIN, 0);
        
        delay(CUP_DELAY);
      }
      
      // rotate cup from CUP_MAX to CUP_MIN degrees
      for (int angle = arm_state[2]; angle < CUP_MIN; angle++) {
        moveMotor ((arm_state[2]), CUP_MOTOR);
        arm_state[2]++; // update arm_state[2] for cup motor

        // blue after placing
        analogWrite(RED_PIN, 0);
        analogWrite(GREEN_PIN, 0);
        analogWrite(BLUE_PIN, 15);
        
        delay(CUP_DELAY);
      }
      
      // rotate top from TOP_MAX to TOP_MIN degrees
      for (int angle = arm_state[1]; angle > TOP_MIN; angle--) {
        moveMotor ((arm_state[1]), TOP_MOTOR);
        arm_state[1]--; // update arm_state[1] for top motor

        // blue after placing
        analogWrite(RED_PIN, 0);
        analogWrite(GREEN_PIN, 0);
        analogWrite(BLUE_PIN, 15);        
        
        delay(TOP_DELAY);
      }

      // blue after placing
      analogWrite(RED_PIN, 0);
      analogWrite(GREEN_PIN, 0);
      analogWrite(BLUE_PIN, 15);        
      
      // force stop after place
      signal_in[2] = 0;
      signal_in[0] = 1;
      arm_routine = STOP;     
      break;
     
    case RESET_POSITION:
      Serial.println("RESET POSITION ROUTINE INITIATED");
      
      // set all motors to starting state
      
      moveMotor (BASE_MIN, BASE_MOTOR);
      // white while reset
      analogWrite(RED_PIN, 15);
      analogWrite(GREEN_PIN, 15);
      analogWrite(BLUE_PIN, 15); 
      delay(500);
      
      moveMotor (TOP_MIN, TOP_MOTOR);
      // white while reset
      analogWrite(RED_PIN, 15);
      analogWrite(GREEN_PIN, 15);
      analogWrite(BLUE_PIN, 15);
      delay(500);
      
      moveMotor (CUP_MIN, CUP_MOTOR);
      // white while reset
      analogWrite(RED_PIN, 15);
      analogWrite(GREEN_PIN, 15);
      analogWrite(BLUE_PIN, 15);
      delay(500);
      
      // reset states for all motors
      arm_state[0] = BASE_MIN;
      arm_state[1] = TOP_MIN;
      arm_state[2] = CUP_MIN;
      break;
    
    case STOP:
      // remain in this state unless input signal changes
      while (!signal_changed) {
        Serial.println("STOP ROUTINE INITIATED");
        
        // red while in stop
        analogWrite(RED_PIN, 255);
        analogWrite(GREEN_PIN, 0);
        analogWrite(BLUE_PIN, 0);

        // check for signal change
        signal_in_change();
        delay(200);
      }
      // no motors are moved
      break;
    
    default: // error: no motors are moved
      Serial.println ("INVALID ROUTINE PROCESSED"); 
  }
}


/* instructions followed during runtime */
void loop() {
  // manage robot state through signals from FPGA's GPIO 
  if (!signal_changed) {
     do_routine();
     Serial.println("ROUTINE GRACEFULLY IMPLEMENTED");
     signal_in_change();
     delay(5);
  }
  else if (signal_changed) {
    set_routine ();
    signal_in_change ();
    Serial.println("SIGNAL GRACEFULLY CHANGED");
    delay(5);
  }
  else { // error
    Serial.println("ERROR: INVALID STATE"); // should not reach here
    delay(500);
  }
  // delay 1ms to make stable transition to start of loop
  delay (1);
}
