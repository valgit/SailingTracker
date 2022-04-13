import Toybox.Graphics;
import Toybox.WatchUi;

// TODO  : add a model
// global ?
// bad design !!!
var _maxspeed;
var mSessMaxSpeedField;

class SailingTrackerView extends CompassView {    
    var mps_to_kts = 1.943844492;
    var m_to_nm = 0.000539957;
    var update_timer = null;
    var headingStr;    
    var _speed;

    function initialize() {
        CompassView.initialize();

        System.println("TrackingView - init");
        // Get the model and controller from the Application
        //mModel = Application.getApp().model;
        //mController = Application.getApp().controller;

		_maxspeed = 0;
        _speed = 0;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        CompassView.onLayout(dc);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        CompassView.onShow();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        CompassView.onUpdate(dc);

        System.println("TrackingView - update");
        drawSailInfo(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        CompassView.onHide();
    }

	function getCurrentSpeed() {
        var info = Activity.getActivityInfo();
        return info.currentSpeed;
    }

	 function drawSailInfo(dc) {     
        var activity = Activity.getActivityInfo();

        //TODO: draw a record icon
        //System.println("isRecording");
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(_canvas_w * 0.7 ,(_canvas_h * 0.10),  5);
		
        // Activity.Info maxSpeed in m/s
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        /*
        var maxSpeed = activity.maxSpeed;
        if (maxSpeed == null) { maxSpeed = 0; }
        maxSpeed = maxSpeed * mps_to_kts;
        maxSpeed = maxSpeed.format("%02.1f");
        */
        var maxSpeed = _maxspeed.format("%02.1f");
        dc.drawText(_canvas_w * 0.88 ,(_canvas_h * 0.43), Graphics.FONT_XTINY, maxSpeed, Graphics.TEXT_JUSTIFY_RIGHT);

        // Activity.Info currentSpeed in m/s
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        /*
        var speed = activity.currentSpeed;
        if (speed == null) { speed = 0; }
        var knots = (_speed * mps_to_kts).format("%02.1f");
        */
        var knots = _speed.format("%02.1f");
        dc.drawText(_canvas_w * 0.70 ,(_canvas_h * 0.30), Graphics.FONT_NUMBER_THAI_HOT, knots, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(_canvas_w * 0.90 ,(_canvas_h * 0.57), Graphics.FONT_LARGE, "kts", Graphics.TEXT_JUSTIFY_VCENTER);


        System.println("cur speed : " + getCurrentSpeed() + " Gspeed "+ knots +" heading : "+headingStr );
        
        // Activity.Info elapsedDistance in meters
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var distance = activity.elapsedDistance;
        if (distance == null) { distance = 0; }
        distance = distance * m_to_nm;
        distance = distance.format("%02.2f");
        dc.drawText(_canvas_w * 0.62, (_canvas_h * 0.70), Graphics.FONT_TINY, distance, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(_canvas_w * 0.62, (_canvas_h * 0.73), Graphics.FONT_XTINY, " nm", Graphics.TEXT_JUSTIFY_LEFT);

        dc.drawText(_canvas_w * 0.50, (_canvas_h * 0.20), Graphics.FONT_MEDIUM, headingStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Activity.Info elapsedTime in ms
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var timer = activity.elapsedTime;
        if (timer == null) { timer = 0; }
        timer = timer / 1000;
        timer = timer / 60;
        //timer = timer / 60 / 60 / 10;

        timer = (timer / 60).format("%02d") + ":" + (timer % 60).format("%02d");
        dc.drawText(_canvas_w * 0.62, (_canvas_h * 0.80), Graphics.FONT_TINY, timer, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(_canvas_w * 0.62, (_canvas_h * 0.83), Graphics.FONT_XTINY, " h", Graphics.TEXT_JUSTIFY_LEFT);
    }	

}
