
/*
 * model for breadcrum trail
 */
import Toybox.System;

class breadCrumb {
    hidden var _numPoint = 1024;
    hidden var _lastpt = 0;
    hidden var _lat = new [1024];
    hidden var _lon = new [1024];

    hidden var _lonMax = -180.0;
    hidden var _lonMin =  180.0;
    hidden var _latMax =  -90.0;
    hidden var _latMin =   90.0;
    hidden var _firstpt = 0;
    hidden var _flat;
    hidden var _flon;
    hidden var _lastTime;

    const EARTHRADIUS = 6371000.0d;  // m
    var scaleDistDeg = (EARTHRADIUS * Math.PI) / 180.0d;  // m/deg

    // define maximum trace length in m to display
    // either with hard coding or by user settings
    // this means only the last 1000m are inside the display 
    // the other points are outside and therefore not visible
    const totalTraceLen = 1000.0;
    //var totalTraceDeg = traceLen / scaleDistDeg;  // deg/1000m

    function initialize() {    
    }
    
    function addPoint(positionInfo) {
        // add point, keep in the limit (1 point per 1min ?)
        // convert in meter
        var _current = positionInfo.position.toDegrees(); // toRadians();
        //System.println("pos is : "+ positionInfo.position);
        //System.println("rad is : " + _current);
        if (!_firstpt) {
            _firstpt = 1;            
            _flat = _current[0];
            _flon = _current[1];
        }
        /*
        Pn.x = (Pn.lon -P0.lon)*cos(P0.lat)*111120 (.toNumber())
        Pn.y = (P0.lat - Pn.lat)*111120 (.toNumber())
        */
        //TODO:  use when to check if intervall is OK
        _lastTime = positionInfo.when;
        System.println("time "+ _lastTime.value());
        _lat[_lastpt] = _current[0];
        _lon[_lastpt] = _current[1];

         // update min/max
        /*
        lonMax = (lonMax > lon[i]) ? lonMax : lon[i];
        lonMin = (lonMin < lon[i]) ? lonMax : lon[i];
        latMax = (latMax > lat[i]) ? latMax : lat[i];
        latMin = (latMin < lat[i]) ? latMax : lat[i];
        */

        _lastpt = _lastpt + 1;
        if (_lastpt > 1024) {
            // overflow !!
            System.print("overflowing");
            _lastpt = 1; // overwrite ?
        }
    }

    function drawBreadcrumb(dc) {
        System.println("drawBreadcrumb - in");
        // overide max with totalTraceDeg if needed
        // scale the geographical size to the display size
        var scaleX = dc.getWidth() / (_lonMax - _lonMin);
        var scaleY = dc.getHeight() / (_latMax - _latMin);
        var scaleXY = (scaleX < scaleY) ? scaleX : scaleY;

        System.println("num point : " + _lastpt);
        var maxpt = _lastpt -1;
        for(var i=0; i < maxpt; i+=1) {
            // calculate point locations in pixels
            var pixelsLon = (lon[i+1] - lon[i]) * scaleXY;
            var pixelsLat = (lat[i+1] - lat[i]) * scaleXY;

            // adjust point locations to a reference point
            var displayY = pixelsLat; // + pixelsYRef;
            var displayX = pixelsLon; // + pixelsXRef;

            //System.println("pt : " + _lat[i] + "," + _lon[i]);
            System.println("dx and dy" + displayX + displayY);
            /*
            // draw points      
            var displayXOld = displayX;
            var displayYOld = displayY;
            System.println("dxold and dyold" + displayXOld + displayYOld);
           
            dc.drawLine(displayXOld, displayYOld, displayX, displayY);
            */
        }
        System.println("drawBreadcrumb - out");
    }

    
}