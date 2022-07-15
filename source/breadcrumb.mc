
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

    //TODO: testing
    hidden var _xlat = new [1024];
    hidden var _ylon = new [1024];

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
        /*
        Pn.x = (Pn.lon -P0.lon)*cos(P0.lat)*111120 (.toNumber())
        Pn.y = (P0.lat - Pn.lat)*111120 (.toNumber())
        */
               
        // should be in seconds
        //System.println("time "+ _lastTime.value() + "-> " + positionInfo.when.value()); // positionInfo.when.value());
        var diff = _lastTime.subtract(positionInfo.when); // .value() - _lastTime.value();
        System.println("time "+ diff.value());
        // TODO: keep only 1 point in 60s
        if (diff.value() > 2) {
            System.println("keep point" + _lastpt);
            _lat[_lastpt] = _current[0];
            _lon[_lastpt] = _current[1];
            _lastTime = positionInfo.when;

             //TRYME: convert to meters
            var pnx = (_current[1] - _flon)*Math.cos(_flat)*111120; //  (.toNumber());
            var pny = (_flat - _current[0])*111120; //  (.toNumber())
            System.println("pos (m) " + pnx + " , " + pny);

            _ylon[_lastpt] = pnx;
            _xlat[_lastpt] = pny;

            //TODO: update min/max
            
            _lonMax = (_lonMax > _ylon[_lastpt]) ? _lonMax : _ylon[_lastpt];
            _lonMin = (_lonMin < _ylon[_lastpt]) ? _lonMax : _ylon[_lastpt];
            _latMax = (_latMax > _xlat[_lastpt]) ? _latMax : _xlat[_lastpt];
            _latMin = (_latMin < _xlat[_lastpt]) ? _latMax : _xlat[_lastpt];            

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
        //TODO: adjust by watches to center
        var pixelsXRef = 120;
        var pixelsYRef = 120;

        var maxpt = _lastpt -1;
        if (maxpt < 3) {
            return;
        }

        // overide max with totalTraceDeg if needed
        // scale the geographical size to the display size
        System.println(_lonMax + " " + _lonMin);
        System.println(_latMax + " " + _latMin);
        /*
        //TODO: reset bornes
        _lonMax = -180.0;
        _lonMin = 180.0;
        _latMax = -90.0;
        _latMin = 90.0;

        for(var i=0; i < maxpt; i++) {            
            _lonMax = (_lonMax > _ylon[i]) ? _lonMax : _ylon[i];
            _lonMin = (_lonMin < _ylon[i]) ? _lonMax : _ylon[i];
            _latMax = (_latMax > _xlat[i]) ? _latMax : _xlat[i];
            _latMin = (_latMin < _xlat[i]) ? _latMax : _xlat[i];
        }
        System.println("lonmax = " + _lonMax);
        System.println("lonmin = " + _lonMin);
        System.println("latmax = " + _latMax);
        System.println("latmin = " + _latMin);
        
        if ( (_lonMax - _lonMin)==0 ) {
            _lonMax = _lonMin +0.01;
        }
        if ( (_latMax - _latMin)==0 ) {
            _latMax = _latMin +0.01;
        }        
        */
        //TODO: get correct scaling
        // may need :
        // having last meter segment dispalay only
        // having something centered around last point
        // (so reverse the distance from start !)
        _lonMin = 0.0;
        _latMin = 0;0;
        _lonMax = 500.0;
        _latMax = 500.0;
        var scaleX = dc.getWidth() / (_lonMax - _lonMin);
        var scaleY = dc.getHeight() / (_latMax - _latMin);
        var scaleXY = (scaleX < scaleY) ? scaleX : scaleY;
        
        System.println("num point : " + _lastpt + " scale: " + scaleXY);
        //FIXME: force 0.03333333 (2')
        //scaleXY = (dc.getHeight() / totalTraceDeg);
        //System.println(" scale 1000m: " + scaleXY);
        //scaleXY = scaleY; // TODO: force to check         
        
        var displayXOld = 0.0;
        var displayYOld = 0.0;
                
        for(var i=0; i < maxpt; i++) {
            // calculate point locations in pixels
            var pixelsLon = (_lon[i+1] - _lon[i]) * scaleXY;
            var pixelsLat = (_lat[i+1] - _lat[i]) * scaleXY;

            // adjust point locations to a reference point
            var displayY = pixelsLat + pixelsYRef;
            var displayX = pixelsLon + pixelsXRef;

            //System.println("pt : " + _lat[i] + "," + _lon[i]);
            

            //dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
            //dc.fillCircle(displayX, displayY, 2);

            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
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

            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(_xlat[i]*scaleXY+120, _ylon[i]*scaleXY+120, _xlat[i+1]*scaleXY+120, _ylon[i+1]*scaleXY+120);            

        }
        // draw last point
        dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(displayXOld, displayYOld, 2);

        System.println("drawBreadcrumb - out");
    }

    
}