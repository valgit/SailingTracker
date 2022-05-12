import Toybox.Activity;
import Toybox.System;
import Toybox.Attention;
import Toybox.FitContributor;
import Toybox.ActivityRecording;

// class to pass actual boat/gps data
//
class BoatInfo
{
	// GPS signal accuracy
	//
	var Accuracy = 0;

	// actual speed in Knots
	//
	var SpeedKnot = 0.0;

	// max speed in knots
	//
	var MaxSpeedKnot = 0.0;

	// avg speed in knots for 10 sec.
	//
	var AvgSpeedKnot = 0.0;

	// Bearing in degree 0-360
	//
	var BearingDegree = 0;

	// is activity recorded
	//
	var IsRecording = false;

	// sliding avg bearing for 20 sec.
	//
	var AvgBearingDegree = 0;
	
	// Total distance covered
	//
	var TotalDistance = 0.0;
	
	// Actual location
	//
	var GpsLocation = null;

    // elapsed time
    var ElapsedTime = 0;

    // True Wind Angle
    var Twd = 0;

    // current vmg
    var vmg = 0;
}

/*
 * central point for GPS data and boat data
 */
class boatModel {
    // avg for 10 sec. values (speed)
    //
	hidden var _avgSpeedIterator = 0;
	hidden var _avgSpeedSum = 0;
	hidden var _avgSpeedValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	
	// max for3 sec. values (speed)
    //
	hidden var _maxSpeedIterator = 0;
	hidden var _maxSpeedSum = 0;
	hidden var _maxSpeedValues = [0, 0, 0];

    // avg for 10 sec. values (bearing)
    //
    hidden var _avgSinValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    hidden var _avgCosValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    hidden var _sinBearingSum = 0;
    hidden var _cosBearingSum = 0;
    hidden var _avgBearingDegree = 0;
    hidden var _avgBearingIterator = 0;

    // actual gps values
    //
	hidden var _speedKnot = 0.0;
    hidden var _accuracy = 0;
    hidden var _bearingDegree = 0;
    hidden var _location = null;

    // global values
    //
    hidden var _startTime;
    hidden var _distance = 0;
    hidden var _duration = 0;
    hidden var _maxSpeedKnot = 0;
    
    hidden var _twd = 0; // 292 test ONO DK 0;
    hidden var _vmg = 0;

    // FIT Contributions variables
    hidden const MAX_SPEED_FIELD_ID = 1;   // speed max
    hidden var mSessMaxSpeedField = null;

    hidden const TWD_FIELD_ID = 2;   // twd !
    hidden var mSessTWDField = null;

    hidden const VMG_FIELD_ID = 3;   // vmg
    hidden var mRecVMGField = null;

    const MAX_SPEED_INTERVAL = 3;
    const AVG_SPEED_INTERVAL = 10;
    const AVG_BEARING_INTERVAL = 10;
    const METERS_PER_NAUTICAL_MILE = 1852;
    const MS_TO_KNOT = 1.9438444924574;

    // Primary stats
    hidden var mHeartRate; 
  
    // FIT recording session
    hidden var mSession;

      // Initialize sensor readings
    function initialize() {    
    	//System.println("model init"); 
        // check for support !
		if( Toybox has :ActivityRecording ) {				
		        // Create a new FIT recording session
		        if ((mSession == null) || (mSession.isRecording() == false)) {
		        	mSession = ActivityRecording.createSession(
		        	 	{
		        	 		// :name=>"diving_"+Time.now().value(), // set session name
		  				   :name=>"Sailing", // +Time.now().value(),      // set session name
		   				   :sport=>ActivityRecording.SPORT_SAILING,        // set sport type
		  				   :subSport=>ActivityRecording.SUB_SPORT_GENERIC//,  // set sub sport type
		  				   //:sensorLogger => mLogger // add accel logger
		    			}
		    
		        	);
		        }		        	
		    	initializeFITRecord();
		    	
		    	initializeFITsession();
		    
                //initializeFITLap();

		   }
    }

    /*
     * fit contributor for Record session 
     */
	function initializeFITRecord() {
	    // Create the new FIT fields to record to.
		        // current values
		        
        mRecVMGField = mSession.createField(WatchUi.loadResource(Rez.Strings.sail_vmg), 
            VMG_FIELD_ID, 
            FitContributor.DATA_TYPE_FLOAT, 
            {:mesgType => FitContributor.MESG_TYPE_RECORD, :units=>WatchUi.loadResource(Rez.Strings.sail_knots)});
    }

    /*
     * FIT contributor for the whole session
     */
    function initializeFITsession() {
        System.println("boatModel - initializeFITsession");
        
        // final values        
        mSessMaxSpeedField = mSession.createField(WatchUi.loadResource(Rez.Strings.sail_maxspeed),
            MAX_SPEED_FIELD_ID, 
            FitContributor.DATA_TYPE_FLOAT, 
            {:mesgType => FitContributor.MESG_TYPE_SESSION, :units=>WatchUi.loadResource(Rez.Strings.sail_knots	)}
            );

        mSessTWDField = mSession.createField(WatchUi.loadResource(Rez.Strings.sail_twd),
            TWD_FIELD_ID, 
            FitContributor.DATA_TYPE_FLOAT, 
            {:mesgType => FitContributor.MESG_TYPE_SESSION, :units=>WatchUi.loadResource(Rez.Strings.sail_angle	)}
            );
    }


    // Start & Pause activity recording
    //
    function StartStopRecording()
    {
        /*
        if (_accuracy < 2 && !_activeSession.isRecording())
        {
            return false;
        }
        */
        if (mSession.isRecording())
        {
            mSession.stop();
            //saveLap();
        }
        else
        {
            mSession.start();
            //_startTime = (_startTime == null) ? Time.now() : _startTime;
        }
        return true;
    }

    // Begin sensor processing
    function start() {
    	//System.println("model - start");        	
    	
        // Start recording
        mSession.start();

    }

    // Stop sensor processing
    function stop() {        
        // Stop the FIT recording
        if ((mSession != null) && mSession.isRecording()) {              
        	mSession.stop();
        }
    }

    // Save the current session
    function save() {
        
    	if (mSession != null) {
            /*
    	    // https://forums.garmin.com/forum/developers/connect-iq/connect-iq-bug-reports/1452620-monkey-graph-doesn-t-display-session-data            
                        
            var mBoatType = Application.getApp().getProperty("boat");
            if (mBoatType != null) {
                //System.println("boat type : " + mBoatType);
                mSessBoatTypeStrField.setData(mBoatType);
            } else {
                mSessBoatTypeStrField.setData("all");
            }

            var mWindSpd = Application.getApp().getProperty("wind");
            if (mWindSpd != null) {
                //System.println("boat type : " + mBoatType);
                mSessWindPerLegField.setData(mWindSpd);
            } else {
                mSessWindPerLegField.setData(0);
            }
  
            
        */       
            mSessMaxSpeedField.setData(_maxSpeedKnot);
            mSessTWDField.setData(_twd);
	        mSession.save();
            }
            // rely on this not null for other
	        mSession = null; 
    }      
    

    // Discard the current session
    function discard() {
        // rely on this not null for other
    	if (mSession != null) {        
	        mSession.discard();
	        mSession = null;
        }
    }

  // Return the total elapsed recording time
    function getTimeElapsed() {
        //return mSeconds;
        
        var _elapsed = 0;
        var activity = Activity.getActivityInfo();
        if (activity != null) {         
            _elapsed = activity.timerTime; //elapsedTime;
            if (_elapsed == null) { _elapsed = 0; }         
        } else {
            	_elapsed = 0;
        } 
        //System.println("elaps : "+ _elapsed);
        _elapsed = _elapsed / 1000; // in ms
        return _elapsed;
        
    }

    // Return the total elapsed recording time
	function getTotalTime() {
		return elapsedTime;
	}	
	
    /*
    function getRaceTime() {        
        var now = System.getTimer(); //Time.now();
        var raceTime = now - _legStart; //.subtract(_legStart);
        var raceTimeStr = secToTimeStr(raceTime/1000); // secToStr(raceTime);// .value());
        //System.println(raceTimeStr);
        return raceTimeStr;
    }
    */

	function toFixed(value, scale) {
        return ((value * scale) + 0.5).toNumber();
    }

    function SetPositionInfo(positionInfo) {
        _speedKnot = positionInfo.speed.toDouble() * MS_TO_KNOT;
        _bearingDegree = (Math.toDegrees(positionInfo.heading) + 360).toNumber() % 360;

		// moving max speed : in order to avoid fluctuation, max speed take as avg from 3 values
		//
		_maxSpeedSum = _maxSpeedSum - _maxSpeedValues[_maxSpeedIterator] + _speedKnot;
        _maxSpeedValues[_maxSpeedIterator] = _speedKnot;
        _maxSpeedIterator = (_maxSpeedIterator + 1) % MAX_SPEED_INTERVAL;
        var maxSpeed = _maxSpeedSum / MAX_SPEED_INTERVAL;
        _maxSpeedKnot = (_maxSpeedKnot < maxSpeed) ? maxSpeed : _maxSpeedKnot;		
        
        // moving avg speed 
        //
        _avgSpeedSum = _avgSpeedSum - _avgSpeedValues[_avgSpeedIterator] + _speedKnot;
        _avgSpeedValues[_avgSpeedIterator] = _speedKnot;
        _avgSpeedIterator = (_avgSpeedIterator + 1) % AVG_SPEED_INTERVAL;

        // moving avg bearing
        //
        var sinBearing = Math.sin(positionInfo.heading);
        var cosBearing = Math.cos(positionInfo.heading);
        _sinBearingSum = _sinBearingSum - _avgSinValues[_avgBearingIterator] + sinBearing;
        _avgSinValues[_avgBearingIterator] = sinBearing;
        _cosBearingSum = _cosBearingSum - _avgCosValues[_avgBearingIterator] + cosBearing;
        _avgCosValues[_avgBearingIterator] = cosBearing;
        _avgBearingDegree = (Math.toDegrees(Math.atan2(_sinBearingSum, _cosBearingSum)) + 360).toNumber() % 360;
        _avgBearingIterator = (_avgBearingIterator + 1) % AVG_BEARING_INTERVAL;

        // vmg
        //

        var _twa = Abs(_twd - _bearingDegree);
        var _vmg = _speedKnot * Math.cos( Math.toRadians(_twa) );
        System.println("VMG is : " + _vmg);
        mRecVMGField.setData(_vmg);

        _location = positionInfo.position;
    }


    	// return all calculated data from GPS 
	//
    function GetBoatInfo()
    {
        var gpsInfo = new BoatInfo();
        gpsInfo.Accuracy = _accuracy;
        gpsInfo.SpeedKnot = _speedKnot;
        gpsInfo.BearingDegree = _bearingDegree;
        gpsInfo.AvgSpeedKnot = _avgSpeedSum / AVG_SPEED_INTERVAL;
        gpsInfo.MaxSpeedKnot = _maxSpeedKnot;
        if (mSession != null) {
            gpsInfo.IsRecording = mSession.isRecording();
        } else {
            gpsInfo.IsRecording = false;
        }
        
        gpsInfo.AvgBearingDegree = _avgBearingDegree;

        var activity = Activity.getActivityInfo();
        var distance = activity.elapsedDistance;
        if (distance == null) { distance = 0; }

        gpsInfo.TotalDistance = _distance / METERS_PER_NAUTICAL_MILE;
        gpsInfo.GpsLocation = _location; 

        var timer = getTimeElapsed();                 
        gpsInfo.ElapsedTime = timer;

        gpsInfo.Twd = _twd;

        //System.println("TWD is : " + info.Twd);
        //var twd = mBoatmodel.getWind();
        //var _twa = Abs(_twd - _bearingDegree);
        //var _vmg = _speedKnot * Math.cos( Math.toRadians(_twa) );
        // System.println("VMG is : " + _vmg);
        gpsInfo.vmg = _vmg;

        return gpsInfo;
    }

    // define the TWD
    function setWind(twd) {
        _twd = twd;
    }

    function getWind() {
        return _twd;
    }
}
