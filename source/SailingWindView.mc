import Toybox.Graphics;
import Toybox.WatchUi;

/*
 * set the TWA
 * head watch to wind, press start to 
 */
class SailingWindView extends CompassView  {    
    //var mps_to_kts = 1.943844492;
    //var m_to_nm = 0.000539957;
 
    function initialize(boat) {
        CompassView.initialize(boat);

        //System.println("SailingWindView - init");
        // Get the model and controller from the Application
        //mController = Application.getApp().controller;                  
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //CompassView.onLayout(dc);
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

        //System.println("SailingWindView - update");

        // Draw TWD-text in a circle
		var fontHeight = dc.getFontHeight(Graphics.FONT_TINY); 
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.fillCircle(_canvas_w/2, _canvas_h/2, 25);
		dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
        dc.drawCircle(_canvas_w/2, _canvas_h/2, 25);

        var mTwd =  "---";
        var actInfo = Sensor.getInfo();	        

	    if (actInfo has :heading)  {
		        var heading_deg = actInfo.heading * 180 / Math.PI;
                mTwd = heading_deg.format("%02.f");        
        }        	

        //System.println("wnd : " + mTwd);
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(_canvas_w/2, _canvas_h/2-fontHeight/2, Graphics.FONT_TINY, mTwd , Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        CompassView.onHide();
     
    }

}