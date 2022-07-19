
/*
 * model for breadcrum trail
 */
using Toybox.System;
using Toybox.Time;
using Toybox.Math;

class breadCrumb {
    hidden var _numPoint = 500; // 1024;
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
    //const totalTraceLen = 1000.0;
    var totalTraceDeg = 10.0 / scaleDistDeg;  // deg/1000m

    function initialize() {    
    }
    
    function addPoint(positionInfo) {
        // add point, keep in the limit (1 point per 1min ?)
        // convert in meter
        var _current = positionInfo.position.toDegrees(); // toRadians();
        //System.println("pos is : "+ positionInfo.position);
        //System.println("rad is : " + _current);
        if (_firstpt == 0 ) {
            _firstpt = 1;            
            _flat = _current[0];
            _flon = _current[1];
            _lastTime = positionInfo.when;
        }
               
        // should be in seconds
        //System.println("time "+ _lastTime.value() + "-> " + positionInfo.when.value()); // positionInfo.when.value());
        var diff = _lastTime.subtract(positionInfo.when); // .value() - _lastTime.value();
        //System.println("time "+ diff.value());
        // TODO: keep only 1 point in 60s
        if (diff.value() > 2) {
            System.println("keep point" + _lastpt);
            _lat[_lastpt] = _current[0];
            _lon[_lastpt] = _current[1];
            _lastTime = positionInfo.when;
          
            //TODO: update min/max
            /*
            _lonMax = (_lonMax > _ylon[_lastpt]) ? _lonMax : _ylon[_lastpt];
            _lonMin = (_lonMin < _ylon[_lastpt]) ? _lonMin : _ylon[_lastpt];
            _latMax = (_latMax > _xlat[_lastpt]) ? _latMax : _xlat[_lastpt];
            _latMin = (_latMin < _xlat[_lastpt]) ? _latMin : _xlat[_lastpt];            
*/
            _lastpt = _lastpt + 1;
            if (_lastpt > _numPoint) {
                // overflow !!
                System.print("overflowing");
                _lastpt = 1; // overwrite ?
            }
        }
    }

    function drawBreadcrumb(dc) {
        System.println("drawBreadcrumb - in, len : " + totalTraceDeg);
        

        var maxpt = _lastpt -1;
        if (maxpt < 3) {
            return;
        }

        // overide max with totalTraceDeg if needed
        // scale the geographical size to the display size
        System.println(_lonMax + " " + _lonMin);
        System.println(_latMax + " " + _latMin);
        
        //TODO: reset bornes
        _lonMax = -180.0;
        _lonMin = 180.0;
        _latMax = -90.0;
        _latMin = 90.0;

        for(var i=0; i < maxpt; i++) {            
            _lonMax = (_lonMax > _lon[i]) ? _lonMax : _lon[i];
            _lonMin = (_lonMin < _lon[i]) ? _lonMin : _lon[i];
            _latMax = (_latMax > _lat[i]) ? _latMax : _lat[i];
            _latMin = (_latMin < _lat[i]) ? _latMin : _lat[i];
        }
        System.println("lonmax = " + _lonMax);
        System.println("lonmin = " + _lonMin);
        System.println("latmax = " + _latMax);
        System.println("latmin = " + _latMin);
        
        //TODO: define min screen size ?
        var scaleX = dc.getWidth() / (_lonMax - _lonMin);
        var scaleY = dc.getHeight() / (_latMax - _latMin);
        var scaleXY = (scaleX < scaleY) ? scaleX : scaleY;
        
        System.println("num point : " + _lastpt + " scale: " + scaleXY);        
        
        var displayXOld = 0.0;
        var displayYOld = 0.0;

        pixelsXRef =  _lat[_lastpt-1] * scaleXY ;
        pixelsYRef =  _lon[_lastpt-1] * scaleXY ;
        System.println("last point : " + pixelsXRef + ","+pixelsYRef);

        //FIXME: get correct value
        //TODO: adjust by watches to center, screen size ?
        var pixelsXRef = 20;
        var pixelsYRef = 200;        

        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        for(var i=0; i < maxpt; i++) {
            // calculate point locations in pixels
            var pixelsLon = (_lon[i] - _lonMin) * scaleXY;
            var pixelsLat = (_lat[i] - _latMin) * scaleXY;

            // adjust point locations to a reference point
            var displayY = pixelsYRef - pixelsLat;
            var displayX = pixelsLon + pixelsXRef;
            
           	// draw lines
            if (i == 0) {
                displayXOld = displayX;
                displayYOld = displayY;
            } else {
                //System.println(i+ " dx and dy " + displayX + " ," + displayY);
                //System.println(i+ " old dx and dy " + displayXOld + " ," + displayYOld);
                dc.drawLine(displayXOld, displayYOld, displayX, displayY);
                displayXOld = displayX;
                displayYOld = displayY;
            }	             
            
        }
        //draw last point        
        dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(displayXOld, displayYOld, 2);        
        //dc.fillCircle(20, 120, 2);

        System.println("drawBreadcrumb - out");
    }

    
}