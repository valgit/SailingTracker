using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
import Toybox.Sensor;
import Toybox.Math;

/*
 * base class for all view during activity recording
 */


/* handle the correct heading from API */
function getHeading() {
	var actInfo = Sensor.getInfo();
	var heading_rad = 0;

	if (actInfo has :heading)  {
		heading_rad = actInfo.heading;
	}
			
	//var map_declination =  0.0;
	//heading_rad= heading_rad+map_declination*Math.PI/180;			
			
	if( heading_rad < 0 ) {
		heading_rad = 2*Math.PI+heading_rad;
	}
	return heading_rad * 57.29; // (180/M_PI )
		
}


class CompassView extends Ui.View {

    hidden var RAY_EARTH = 6378137; 
    hidden var heading_rad = null;

    hidden var northStr="";
    hidden var eastStr="";
    hidden var southStr="";
    hidden var westStr="";
    hidden var center_x;
	hidden var center_y;
	hidden var size_max;
	
	var mBoatmodel;
    var mController;

 	var _canvas_w;
    var _canvas_h;
	var _screenShape;

	function initialize(boat) {
		View.initialize();

		// Load UI resources	
		northStr = Ui.loadResource(Rez.Strings.north);
		eastStr = Ui.loadResource(Rez.Strings.east);
		southStr = Ui.loadResource(Rez.Strings.south);
		westStr = Ui.loadResource(Rez.Strings.west);		
        
        // Get the model and controller from the Application
        mBoatmodel = boat;
        //mController = Application.getApp().controller;
		_screenShape = System.getDeviceSettings().screenShape;
	}
        
    function onShow() as Void {
		//mController.onShow();
    }

    function onHide() as Void {
    	//mController.onHide();
    }
    
    function onLayout(dc as Dc) as Void {
		_canvas_w = dc.getWidth();
        _canvas_h = dc.getHeight();      

    	size_max = dc.getWidth() > dc.getHeight() ? dc.getHeight() : dc.getWidth();
    	center_x = dc.getWidth() / 2;
		center_y = dc.getHeight() / 2;
    }
    
	function onUpdate(dc as Dc) as Void {  

	    dc.setColor(Gfx.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();  

		// time
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var clockTime = System.getClockTime();
        var time = clockTime.hour.format("%02d") + ":" + clockTime.min.format("%02d");
        dc.drawText(_canvas_w * 0.50 ,(_canvas_h * 0.05), Graphics.FONT_MEDIUM, time, Graphics.TEXT_JUSTIFY_CENTER);

		heading_rad = getHeading();

		// heading arrow        							
		//drawLogoOrientation(dc, center_x, center_y, size_max, heading_rad);
		/*				
		var display_text_orientation = App.getApp().getProperty("display_text_orientation");
			
		if( display_text_orientation ){
			var y = center_y ;
			var size = size_max;

			drawTextOrientation(dc, center_x, y, size, heading_rad);
		}*/
						
		//drawCompass(dc, center_x, center_y, size_max);
		drawHashMarks(dc);

		// Draw North arrow
        drawNorth(dc,heading_rad);
	}
    

	/*
	 * battery status
	 */
   	function drawbattery(dc) {
		// battery info ?
        var battery = System.getSystemStats().battery;
        if (battery <= 30) {
            if (battery <= 10) {
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            }
            dc.drawText(width * 0.30 ,(height * 0.05), Graphics.FONT_MEDIUM, "B", Graphics.TEXT_JUSTIFY_CENTER);
        }
	   }

	  // Draws the clock tick marks around the outside edges of the screen.
	// ==========================================================================
    function drawHashMarks(dc) {
		dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(2);

        // Draw hashmarks differently depending on screen geometry.
        if (System.SCREEN_SHAPE_ROUND == _screenShape) {
            var sX, sY;
            var eX, eY;
            var outerRad = _canvas_w / 2;
            var innerRad = outerRad - 9;
            
            // draw 10-deg tick marks.
            for (var i = 0; i < 2 * Math.PI ; i += (Math.PI / 18)) {
                sY = outerRad + innerRad * Math.sin(i);
                eY = outerRad + outerRad * Math.sin(i);
                sX = outerRad + innerRad * Math.cos(i);
                eX = outerRad + outerRad * Math.cos(i);
                dc.drawLine(sX, sY, eX, eY);
            }

            // draw 10-deg tick marks.
            innerRad = outerRad - 5;
            for (var i = 0; i < 2 * Math.PI ; i += (Math.PI / 90)) {
                sY = outerRad + innerRad * Math.sin(i);
                eY = outerRad + outerRad * Math.sin(i);
                sX = outerRad + innerRad * Math.cos(i);
                eX = outerRad + outerRad * Math.cos(i);
                dc.drawLine(sX, sY, eX, eY);
            }
            
        } else {
            var coords = [0, _canvas_w / 4, (3 * _canvas_w) / 4, _canvas_w];
            for (var i = 0; i < coords.size(); i += 1) {
                var dx = ((_canvas_w / 2.0) - coords[i]) / (_canvas_h / 2.0);
                var upperX = coords[i] + (dx * 10);
                // Draw the upper hash marks.
                dc.fillPolygon([[coords[i] - 1, 2], [upperX - 1, 12], [upperX + 1, 12], [coords[i] + 1, 2]]);
                // Draw the lower hash marks.
                dc.fillPolygon([[coords[i] - 1, _canvas_h-2], [upperX - 1, _canvas_h - 12], [upperX + 1, _canvas_h - 12], [coords[i] + 1, _canvas_h - 2]]);
            }
        }
    }

	//=====================
    // Draws North 
    //=====================
    function drawNorth(dc,heading) {
		/*
    	if (m_bDrawNWSE==false){
    		return;
    	}*/
    	
		dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
		var fontHeight = dc.getFontHeight(Graphics.FONT_TINY); 

		var i = -(heading+90)/180.0 * Math.PI;
        var X = ((_canvas_h/2)-20) * Math.cos(i);
        var Y = ((_canvas_w/2)-20) * Math.sin(i);
    	dc.drawText(X + (_canvas_h/2), Y + (_canvas_w/2) - fontHeight/2, Graphics.FONT_TINY, "N", Graphics.TEXT_JUSTIFY_CENTER);
 		
		i = -(heading)/180.0 * Math.PI;
        X = ((_canvas_h/2)-20) * Math.cos(i);
        Y = ((_canvas_w/2)-20) * Math.sin(i);
    	dc.drawText(X + (_canvas_h/2), Y + (_canvas_w/2) - fontHeight/2, Graphics.FONT_TINY, "E", Graphics.TEXT_JUSTIFY_CENTER);

		i = -(heading-90)/180.0 * Math.PI;
        X = ((_canvas_h/2)-20) * Math.cos(i);
        Y = ((_canvas_w/2)-20) * Math.sin(i);
    	dc.drawText(X + (_canvas_h/2), Y + (_canvas_w/2) - fontHeight/2, Graphics.FONT_TINY, "S", Graphics.TEXT_JUSTIFY_CENTER);

		i = -(heading+180)/180.0 * Math.PI;
        X = ((_canvas_h/2)-20) * Math.cos(i);
        Y = ((_canvas_w/2)-20) * Math.sin(i);
    	dc.drawText(X + (_canvas_h/2), Y + (_canvas_w/2) - fontHeight/2, Graphics.FONT_TINY, "W", Graphics.TEXT_JUSTIFY_CENTER);
    }

}
