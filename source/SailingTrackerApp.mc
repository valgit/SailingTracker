import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Position as Position;
using Toybox.Timer;

class SailingTrackerApp extends Application.AppBase {
    var mSupportsRecording;
    var mTimer;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));

        try {
            // code that might throw an exception
           
             // Enable the WHR or ANT HR sensor
            // FYI: if a Tempe is available it's data will be included in the .fit and seen on Garmin Connect
            Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE,Sensor.SENSOR_TEMPERATURE]);
            // add a listener (http://developer.garmin.com/connect-iq/programmers-guide/positioning-sensors/)
            //Sensor.enableSensorEvents( method( :onSensor ) );
            //System.println("Sensor rate : " + Sensor.getMaxSampleRate());
        }
        catch (ex) {
                Toybox.System.println(ex.getErrorMessage());
                ex.printStackTrace();
            
                // rethrow if you want to let it crash
                throw ex;
        }
        mSupportsRecording = Toybox has :ActivityRecording;  

        // Create a counter that increments by one each second
		mTimer = new Timer.Timer();
		mTimer.start(method(:timerCallback), 1000, true);
  
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new SailingTrackerView(), new SailingTrackerDelegate() ] as Array<Views or InputDelegates>;
    }

     // handle position event
    //
    function onPosition(info) 
    {
        //_gpsWrapper.SetPositionInfo(info);
    }

    function timerCallback() {    
        WatchUi.requestUpdate();
        // may call other things here ?
    }
}

function getApp() as SailingTrackerApp {
    return Application.getApp() as SailingTrackerApp;
}