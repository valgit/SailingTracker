using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.Sensor;
import Toybox.Math;

/*
 * race count down timer 
 * ISAF rules
 */

class countdownView extends Ui.View {
	
	var mBoatmodel; //TODO: race model ?

 	var _canvas_w;
    var _canvas_h;
    var _timerValue = 0;

	function initialize(boat) {
		View.initialize();
        
        // Get the model and controller from the Application
        mBoatmodel = boat;
        //mController = Application.getApp().controller;
        //App.getApp().getDefaultTimerCount();
        _timerValue = Application.getApp().getProperty("defaultTimer");         

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
    	    	
    }
    
	function onUpdate(dc as Dc) as Void {  

	    dc.setColor(Gfx.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_canvas_w * 0.50 ,(_canvas_h * 0.05), Graphics.FONT_MEDIUM, _timerValue, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
