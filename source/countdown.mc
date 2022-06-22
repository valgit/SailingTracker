/*
 * handle the countdown timer global model
 */

class Countdown {
    hidden var _defaultTime;
    hidden var _current;

    function initialize(int initValue) {    
        _defaultTime = initValue;
    }
    
    // add 1 min to current time
    function dialUp() {

    }

    // remove 1 min to current
    function dialDown() {

    }

    function resetTimer() {
        _current = _defaultTime;
    }

    // check if timer is running
    function isRunning() {
        return false;
    }

    // should be call each second
    function updateTime() {

    }

    // return the curren value in seconds
    function getCurrentTimer() {
        return _current;
    }
}
