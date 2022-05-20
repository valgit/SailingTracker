
/*
 * model for breadcrum trail
 */
import Toybox.System;

class breadCrumb {
    hidden var _numPoint = 1024;
    hidden var _lat[];
    hidden var _lon[];

    hidden var _lonMax = -180.0;
    hidden var _lonMin =  180.0;
    hidden var _latMax =  -90.0;
    hidden var _latMin =   90.0;

    function initialize() {    
    }
    
    function addPoint(positionInfo) {
        // add point, keep in the limit (1 point per 1min ?)
        // convert in meter
        /*
        Pn.x = (Pn.lon -P0.lon)*cos(P0.lat)*111120 (.toNumber())
        Pn.y = (P0.lat - Pn.lat)*111120 (.toNumber())
        */

        // update min/max
        /*
        lonMax = (lonMax > lon[i]) ? lonMax : lon[i];
        lonMin = (lonMin < lon[i]) ? lonMax : lon[i];
        latMax = (latMax > lat[i]) ? latMax : lat[i];
        latMin = (latMin < lat[i]) ? latMax : lat[i];
        */
    }

    function drawBreadcrumb(dc) {

    }
}