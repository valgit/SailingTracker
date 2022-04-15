/*
 * some common and usefull functions
 */
import Toybox.Application;
import Toybox.Math;
import Toybox.Sensor;
import Toybox.Time;
import Toybox.Lang;

// ms to [[hh:]m]m:ss
function SecToString(timeInSec)
{
    var hour = timeInSec / Time.Gregorian.SECONDS_PER_HOUR;
    var min = (timeInSec.toLong() % Time.Gregorian.SECONDS_PER_HOUR) / Time.Gregorian.SECONDS_PER_MINUTE;
    var sec = (timeInSec.toLong() % Time.Gregorian.SECONDS_PER_HOUR) % Time.Gregorian.SECONDS_PER_MINUTE;
    
    return Lang.format(
        "$1$:$2$:$3$", 
        [hour.format("%02d"), min.format("%02d"), sec.format("%02d")]);
    
}
    
// return absolute number
//
function Abs(x)
{
    return (x < 0) ? -x : x;
}

function secToStr(raceTime)
{
    var raceSec = (raceTime % 60).format("%02d");
    var raceMin = ((raceTime / 60) % 60).format("%02d");
    //var raceHours = ((raceTime / 3600) % 60).format("%02d");
    
    return ""+raceMin+":"+raceSec;
}

       
function toHMS(secs) {
    var hr = secs/3600;
    var min = (secs-(hr*3600))/60;
    var sec = secs%60;
    return [hr, min,sec];
}

/* handle the correct heading from API */
function getHeading() {
	var actInfo = Sensor.getInfo();
	var heading_rad = 0;

	if (actInfo has :heading)  {
		heading_rad = actInfo.heading;
	}
    		
	if( heading_rad < 0 ) {
		heading_rad = 2*Math.PI+heading_rad;
	}
	return heading_rad;
		
}

function headingToStrRad(heading){
    var sixteenthPI = Math.PI / 16.0;
    if (heading < sixteenthPI and heading >= 0){
        return "N";
    }else if (heading < (3 * sixteenthPI)){ 
        return "NNE";
    }else if (heading < (5 * sixteenthPI)){ 
        return "NE";
    }else if (heading < (7 * sixteenthPI)){ 
        return "ENE";
    }else if (heading < (9 * sixteenthPI)){ 
        return "E";
    }else if (heading < (11 * sixteenthPI)){ 
        return "ESE";
    }else if (heading < (13 * sixteenthPI)){ 
        return "SE";
    }else if (heading < (15 * sixteenthPI)){ 
        return "SSE";
    }else if (heading < (17 * sixteenthPI)){ 
        return "S";
    }else if ((heading < 0 and heading > (15 * sixteenthPI) * -1)){ 
        return "SSW";
    }else if ((heading < 0 and heading > (14 * sixteenthPI) * -1)){ 
        return "SW";
    }else if ((heading < 0 and heading > (13 * sixteenthPI) * -1)){ 
        return "WSW";
    }else if ((heading < 0 and heading > (9 * sixteenthPI) * -1)){ 
        return "W";
    }else if ((heading < 0 and heading > (7 * sixteenthPI) * -1)){ 
        return "WNW";
    }else if ((heading < 0 and heading > (5 * sixteenthPI) * -1)){ 
        return "NW";
    }else if ((heading < 0 and heading > (3 * sixteenthPI) * -1)){ 
        return "NNW";
    }else {
        return "-";
    }
}    

function headingToStrDeg(heading){
    //rose des vents 32 Points cardinaux 
    var sixteenthPI = 180.0 / 16.0;
    if (heading < sixteenthPI and heading >= 0){
        return "N";
    }else if (heading < (3 * sixteenthPI)){ 
        return "NNE";
    }else if (heading < (5 * sixteenthPI)){ 
        return "NE";
    }else if (heading < (7 * sixteenthPI)){ 
        return "ENE";
    }else if (heading < (9 * sixteenthPI)){ 
        return "E";
    }else if (heading < (11 * sixteenthPI)){ 
        return "ESE";
    }else if (heading < (13 * sixteenthPI)){ 
        return "SE";
    }else if (heading < (15 * sixteenthPI)){ 
        return "SSE";
    }else if (heading < (17 * sixteenthPI)){ 
        return "S";
    }else if (heading < (19 * sixteenthPI)){ 
        return "SSW";
    }else if (heading < (21 * sixteenthPI)){ 
        return "SW";
    }else if (heading < (23 * sixteenthPI)){ 
        return "WSW";
    }else if (heading < (25 * sixteenthPI)){ 
        return "W";
    }else if (heading < (27 * sixteenthPI)){ 
        return "WNW";
    }else if (heading < (29 * sixteenthPI)){ 
        return "NW";
    }else if (heading < (31 * sixteenthPI)){ 
        return "NNW";
    }else if (heading < (33 * sixteenthPI)){ 
        return "N";
    }else {
        return "-";
    }
}    

// heading is in Degree...
function formatHeading(heading) {          
        var headingStr = headingToStrDeg(heading);
        /*
        var headingDeg = ((180 * heading ) /  Math.PI);
        if (headingDeg < 0) {
            headingDeg += 360;
        }
        */
        headingStr += " - " + heading.format("%d");
        return headingStr;
}

// Return min of two values
function min(a, b) {
        if(a < b) {
            return a;
        }
        else {
            return b;
        }
}

// Return max of two values
function max(a, b) {
        if(a > b) {
            return a;
        }
        else {
            return b;
        }
}

// Return the boolean value for the preference
// @param name the name of the preference
// @param def the default value if preference value cannot be found
function getBoolean(name, def) {
    var app = getApp();
    var pref = def;

    if (app != null) {
        pref = app.getProperty(name);
        //pref = Application.Properties.getValue(name);

        if (pref != null) {
            if (pref instanceof Toybox.Lang.Boolean) {
                return pref;
            }

            if (pref == 1) {
                return true;
            }
        } else {
        	return def; 
        }
    }
}

//! Return the number value for a preference, or the given default value if pref
//! does not exist, is invalid, is less than the min or is greater than the max.
//! @param name the name of the preference
//! @param def the default value if preference value cannot be found
//! @param min the minimum authorized value for the preference
//! @param max the maximum authorized value for the preference
function getNumber(name, def, min, max) {
    var app = getApp();
    var pref = def;

    if (app != null) {
        pref = app.getProperty(name);

        if (pref != null) {
            // GCM used to return value as string
            if (pref instanceof Toybox.Lang.String) {
                try {
                    pref = pref.toNumber();
                } catch(ex) {
                    pref = null;
                }
            }
        }
    }

    // Run checks
    if (pref == null || pref < min || pref > max) {
        pref = def;
        app.setProperty(name, pref);
    }

    return pref;
}

