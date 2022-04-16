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

        var mTwd =  "---";

        //System.println("SailingWindView - update");
        mTwd = mBoatmodel.getWind().format("%02.f");
        var fontHeight = dc.getFontHeight(Graphics.FONT_SMALL); 

        // Draw Set TWD in circle
        /* was
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.fillCircle(_canvas_w/2, _canvas_h/2 + 30, 40);
		dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
        dc.drawCircle(_canvas_w/2, _canvas_h/2 + 30 , 40);

        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(_canvas_w/2, _canvas_h/2-fontHeight/2 + 35, Graphics.FONT_SMALL, mTwd , Graphics.TEXT_JUSTIFY_CENTER);
        */
        // Draw Set TWD in circle 
        // TODO : add 180° for opposite ?
		fontHeight = dc.getFontHeight(Graphics.FONT_MEDIUM); 
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.fillCircle(_canvas_w/2, _canvas_h/2, 25);
		dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
        dc.drawCircle(_canvas_w/2, _canvas_h/2, 25);        
        
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(_canvas_w/2, _canvas_h/2-fontHeight/2, Graphics.FONT_SMALL, mTwd , Graphics.TEXT_JUSTIFY_CENTER);

        // Draw live HDG
        var heading_deg  = getHeading() * 57.29; // 180 / Math.PI;
        mTwd = formatHeading(heading_deg);

        //System.println("wnd : " + mTwd);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.drawText(_canvas_w/2, _canvas_h/4, Graphics.FONT_MEDIUM, mTwd , Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        CompassView.onHide();
     
    }

}