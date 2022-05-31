
/*
 * model for breadcrum trail
 */
import Toybox.System;

class breadCrumb {
    hidden var _numPoint = 1024;
    hidden var _laspt = 0;
    hidden var _lat[];
    hidden var _lon[];

    hidden var _lonMax = -180.0;
    hidden var _lonMin =  180.0;
    hidden var _latMax =  -90.0;
    hidden var _latMin =   90.0;
    hidden var _firstpt = 0;
    hidden var _flat;
    hidden var _flon;

    function initialize() {    
    }
    
    function addPoint(positionInfo) {
        // add point, keep in the limit (1 point per 1min ?)
        // convert in meter
        var _current = positionInfo.position.toRadians();
        if (!_first) {
            _first = 1;            
            _flat = _current[0];
            _flon = _current[1];
        }
        /*
        Pn.x = (Pn.lon -P0.lon)*cos(P0.lat)*111120 (.toNumber())
        Pn.y = (P0.lat - Pn.lat)*111120 (.toNumber())
        */
        _lat[_lastpt] = _current[0];
        _lon[_lastpt] = _current[1];

         // update min/max
        /*
        lonMax = (lonMax > lon[i]) ? lonMax : lon[i];
        lonMin = (lonMin < lon[i]) ? lonMax : lon[i];
        latMax = (latMax > lat[i]) ? latMax : lat[i];
        latMin = (latMin < lat[i]) ? latMax : lat[i];
        */

        _lastpt = _lastps + 1;
        if (_lastpt > 1024) {
            // overflow !!
            System.print("overflowing");
            _lastpt = 1; // overwrite ?
        }
    }

    function drawBreadcrumb(dc) {

    }
}