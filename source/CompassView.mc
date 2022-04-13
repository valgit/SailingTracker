using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.Sensor;
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
			
	var map_declination =  0.0;
		heading_rad= heading_rad+map_declination*Math.PI/180;			
			
	if( heading_rad < 0 ) {
		heading_rad = 2*Math.PI+heading_rad;
	}
	return heading_rad;
		
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
						
		var display_text_orientation = App.getApp().getProperty("display_text_orientation");
			
		if( display_text_orientation ){
			var y = center_y ;
			var size = size_max;

			drawTextOrientation(dc, center_x, y, size, heading_rad);
		}
						
		drawCompass(dc, center_x, center_y, size_max);
	}
    
	function drawTextOrientation(dc, center_x, center_y, size, orientation){
		var color = Graphics.COLOR_LT_GRAY;
		var fontOrientaion;
		var fontMetric = Graphics.FONT_TINY;

       	if( orientation < 0 ) {
				orientation = 2*Math.PI+orientation;
		}
		var orientationStr=Lang.format("$1$", [(orientation*180/Math.PI).format("%d")]);
		
		fontOrientaion = Graphics.FONT_NUMBER_THAI_HOT ;
		
		dc.setColor(color, Graphics.COLOR_TRANSPARENT);
		dc.drawText(center_x, center_y, fontOrientaion, orientationStr, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
		
		var text_width = dc.getTextWidthInPixels(orientationStr, fontOrientaion);
		var text_height =dc.getFontHeight(fontOrientaion);
		dc.drawText(center_x+text_width/2+2, center_y-text_height/4+2, fontMetric, "o", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
		
	}
	   
	function drawCompass(dc, center_x, center_y, size) {
		var colorText = Graphics.COLOR_WHITE;
		var colorTextNorth = Graphics.COLOR_WHITE;
		var colorCompass = Graphics.COLOR_RED;
		var radius = size/2-12;
		var font=Graphics.FONT_MEDIUM;
		var penWidth = 8;
		var step = 12;

		dc.setColor(colorTextNorth, Graphics.COLOR_TRANSPARENT);
		drawTextPolar(dc, center_x, center_y, heading_rad, radius, font, northStr);
             
		dc.setColor(colorText, Graphics.COLOR_TRANSPARENT);
		drawTextPolar(dc, center_x, center_y, heading_rad + 3*Math.PI/2, radius, font, eastStr);
        
		dc.setColor(colorText, Graphics.COLOR_TRANSPARENT);
		drawTextPolar(dc, center_x, center_y, heading_rad+ Math.PI, radius, font, southStr);

		dc.setColor(colorText, Graphics.COLOR_TRANSPARENT);
		drawTextPolar(dc, center_x, center_y, heading_rad+ Math.PI / 2, radius, font, westStr);
        
		var startAngle = heading_rad*180/Math.PI - step;
		var endAngle = heading_rad*180/Math.PI + 90+ step;
       	dc.setColor(colorCompass, Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(penWidth);
		for( var i = 0; i < 4; i++ ) {
			dc.drawArc(center_x, center_y, radius, Gfx.ARC_CLOCKWISE, 90+startAngle-i*90, (360-90+endAngle.toLong()-i*90)%360 );
		}
		
		dc.setPenWidth(penWidth/4);
		for( var i = 0; i < 12; i++) {
			if( i % 3 != 0 ) {
				var xy1 = pol2Cart(center_x, center_y, heading_rad+i*Math.PI/6, radius);
				var xy2 = pol2Cart(center_x, center_y, heading_rad+i*Math.PI/6, radius-radius/10);
				dc.drawLine(xy1[0],xy1[1],xy2[0],xy2[1]);
			}
		}      
	}
    
	function drawLogoOrientation(dc, center_x, center_y, size, orientation){
		var color = Graphics.COLOR_WHITE;
		var radius=size/3.10;
		
		dc.setColor(color, Graphics.COLOR_TRANSPARENT);
	
		var xy1 = pol2Cart(center_x, center_y, orientation, radius);
		var xy2 = pol2Cart(center_x, center_y, orientation+135*Math.PI/180, radius);
		var xy3 = pol2Cart(center_x, center_y, orientation+171*Math.PI/180, radius/2.5);
		var xy4 = pol2Cart(center_x, center_y, orientation, radius/3);
		var xy5 = pol2Cart(center_x, center_y, orientation+189*Math.PI/180, radius/2.5);
		var xy6 = pol2Cart(center_x, center_y, orientation+225*Math.PI/180, radius);
		dc.fillPolygon([xy1, xy2, xy3, xy4, xy5, xy6]);
	}
    
	function drawTextPolar(dc, center_x, center_y, radian, radius, font, text) {
		var xy = pol2Cart(center_x, center_y, radian, radius);
		dc.drawText(xy[0], xy[1], font, text, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
	}
    
	function pol2Cart(center_x, center_y, radian, radius) {
		var x = center_x - radius * Math.sin(radian);
		var y = center_y - radius * Math.cos(radian);
		 
		return [Math.ceil(x), Math.ceil(y)];
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
}
