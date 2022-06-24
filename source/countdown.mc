/*
 * handle the countdown timer global model
 */

//import Toybox.System;

class Countdown {
    hidden var _defaultTime;

    // Status
    hidden var _timerComplete = false;
    hidden var _timerRunning = false;
 
    // Properties
    var _secLeft;
    var finalRingTime = 5000;    

    function initialize(initValue) {    
        _defaultTime = initValue; // in min
        resetTimer();
    }
    
     // add 1 min to current time
     function fixTimeUp() {
        if (_timerRunning == false) {
            return;
        }
        _secLeft = (_secLeft  + 60);
        //System.println("fixTimeUp: " + (_secLeft / 60));        
    }

    // remove 1 min to current
    function fixTimeDown() {
        if (_timerRunning == false) {
            return;
        }
         _secLeft = (_secLeft - 60);
        //System.println("fixTimeDown: " + _secLeft / 60);        
    }

    function endTimer() {        
        _timerRunning = false;
        _timerComplete = true;
    }

    function resetTimer() {
        _secLeft = _defaultTime * 60;
    }

    function getDefaultTimer() {
        return _defaultTime * 60;
    }

    // check if timer is running
    function isTimerComplete() {
        return _timerComplete;
    }

    function isTimerRunning() {
        return _timerRunning;
    }

    function secondsLeft() {
        return _secLeft;
    }    

    function startTimer() {
        if (_timerRunning == true) {
            return;
        }
        _secLeft = _defaultTime * 60;        
        _timerRunning = true;
    }

    function updateTimer() {
    	_secLeft -= 1;
    }


    // return the curren value in seconds
    function getCurrentTimer() {
        return _secLeft;
        //return [secLeft,color];
    }
  
}
