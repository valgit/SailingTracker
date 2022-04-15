import Toybox.Graphics;
import Toybox.WatchUi;

class SailingTrackerView extends WatchUi.View /* CompassView */ {    
    //var mps_to_kts = 1.943844492;
    //var m_to_nm = 0.000539957;
    var mBoatmodel;
    //var mController;

    hidden var center_x;
	hidden var center_y;
	hidden var size_max;

 	hidden var _canvas_w;
    hidden var _canvas_h;

    function initialize(boat) {
        View.initialize();

        System.println("TrackingView - init");
        // Get the model and controller from the Application
        //mController = Application.getApp().controller;          
        mBoatmodel = boat;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        View.onLayout(dc);

        _canvas_w = dc.getWidth();
        _canvas_h = dc.getHeight();      

    	size_max = _canvas_w > _canvas_h ? _canvas_h : _canvas_w;
    	center_x = _canvas_w / 2;
		center_y = _canvas_h / 2;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        View.onShow();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var _info = mBoatmodel.GetBoatInfo();
        
        // time
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var clockTime = System.getClockTime();
        var time = clockTime.hour.format("%02d") + ":" + clockTime.min.format("%02d");
        dc.drawText(_canvas_w * 0.50 ,(_canvas_h * 0.05), Graphics.FONT_MEDIUM, time, Graphics.TEXT_JUSTIFY_CENTER);

        //System.println("TrackingView - update");
        drawSailInfo(dc, _info);

        var recordingStatus = _info.IsRecording;
        drawRecord(dc,recordingStatus);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        View.onHide();
    }

	 function drawSailInfo(dc,info) {     
        //var activity = Activity.getActivityInfo();

        // Display speed and bearing if GPS available        
		
        // Activity.Info maxSpeed in m/s
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        var maxSpeed = info.MaxSpeedKnot.format("%02.1f");
        dc.drawText(_canvas_w * 0.88 ,(_canvas_h * 0.43), Graphics.FONT_XTINY, maxSpeed, Graphics.TEXT_JUSTIFY_RIGHT);

        // Activity.Info currentSpeed in m/s
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var knots = info.SpeedKnot.format("%02.1f");
        dc.drawText(_canvas_w * 0.70 ,(_canvas_h * 0.30), Graphics.FONT_NUMBER_THAI_HOT, knots, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(_canvas_w * 0.90 ,(_canvas_h * 0.57), Graphics.FONT_LARGE, "kn", Graphics.TEXT_JUSTIFY_VCENTER);

        var headingStr = formatHeading(info.BearingDegree);
        //System.println("cur speed " + knots +" kts - heading : "+headingStr );
        
        //  show VMG ?
        //System.println("TWD is : " + info.Twd);
        //var twd = mBoatmodel.getWind();
        var vmg = info.SpeedKnot * Math.cos((info.Twd-info.BearingDegree)* 0.0174532 ); //  (pi /180 )
        //System.println("vmg is : " + vmg);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        var vmgStr = vmg.format("%02.1f");
        dc.drawText(_canvas_w * 0.12 ,(_canvas_h * 0.43), Graphics.FONT_XTINY, vmgStr, Graphics.TEXT_JUSTIFY_RIGHT);

        // Activity.Info elapsedDistance in meters
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var distance = info.TotalDistance;
        
        //distance = distance * m_to_nm;
        distance = distance.format("%02.2f");
        dc.drawText(_canvas_w * 0.62, (_canvas_h * 0.70), Graphics.FONT_TINY, distance, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(_canvas_w * 0.62, (_canvas_h * 0.73), Graphics.FONT_XTINY, " nm", Graphics.TEXT_JUSTIFY_LEFT);

        dc.drawText(_canvas_w * 0.50, (_canvas_h * 0.20), Graphics.FONT_MEDIUM, headingStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Activity.Info elapsedTime in ms
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var timer = info.ElapsedTime;
        timer = (timer / 60).format("%02d") + ":" + (timer % 60).format("%02d");
        dc.drawText(_canvas_w * 0.62, (_canvas_h * 0.80), Graphics.FONT_TINY, timer, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(_canvas_w * 0.62, (_canvas_h * 0.83), Graphics.FONT_XTINY, " h", Graphics.TEXT_JUSTIFY_LEFT);
        
        //System.println("cur dist " + distance +" nm - time : "+timer );

        
    }	

    // Draw a record icon
    function drawRecord(dc,recordingStatus) {                       
        //System.println("isRecording : " + recordingStatus);
        dc.setColor(recordingStatus ? Graphics.COLOR_GREEN : Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(_canvas_w * 0.7 ,(_canvas_h * 0.10),  5);
    }
}
