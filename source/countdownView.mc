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

	function initialize(boat) {
		View.initialize();
        
        // Get the model and controller from the Application
        mBoatmodel = boat;
        //mController = Application.getApp().controller;
        //App.getApp().getDefaultTimerCount();
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

    	size_max = _canvas_w > _canvas_h ? _canvas_h : _canvas_w;
    	center_x = _canvas_w / 2;
		center_y = _canvas_h / 2;
    }
    
	function onUpdate(dc as Dc) as Void {  

	    dc.setColor(Gfx.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();  
    }
}
