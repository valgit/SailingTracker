using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
import Toybox.Attention;
import Toybox.Math;

/*
 * race count down timer 
 * ISAF rules
 */

class countdownView extends Ui.View {
	
	hidden var mBoatmodel; //TODO: race model ?

 	hidden var _canvas_w;
    hidden var _canvas_h;
    hidden var _timerValue = 0;

    hidden var _countTimer = null;
    hidden var vibeData;

	function initialize(timer) {
		View.initialize();
        
        // Get the model and controller from the Application
        //mBoatmodel = boat;
        //mController = Application.getApp().controller;
        //App.getApp().getDefaultTimerCount();
        //_timerValue = Application.getApp().getProperty("defaultTimer");         
        _countTimer = timer; // new Countdown(_timerValue);

        // create vibrate profile
        if (Attention has :vibrate) {
            vibeData =
            [
                new Attention.VibeProfile(50, 500) // On for two seconds
            ];
        }

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
    
    function formatTimer() {
        var secLeft = _countTimer.secondsLeft();

        var sec = secLeft % 60;
        var min = secLeft / 60;

        //format
        var countDownStr;
        if(min > 0) {
            countDownStr = min.format("%d") + ":" + sec.format("%02d");
        }else {
            countDownStr = sec.format("%d");
        }
        return countDownStr;
    }

	function onUpdate(dc as Dc) as Void {  
        
        dc.setColor(Gfx.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var strTime = formatTimer();
        if (_countTimer.isTimerRunning()) {
            updateTime();
            // show progress
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
            dc.drawText( _canvas_w * 0.50 ,(_canvas_h * 0.50) - (Gfx.getFontAscent(Gfx.FONT_NUMBER_THAI_HOT) / 2),
                Graphics.FONT_NUMBER_THAI_HOT, 
                strTime, 
                Gfx.TEXT_JUSTIFY_CENTER );
        } else
        if (_countTimer.isTimerComplete()) {            
            dc.drawText( _canvas_w * 0.50 ,(_canvas_h * 0.50) - (Gfx.getFontAscent(Gfx.FONT_NUMBER_THAI_HOT) / 2),
                Graphics.FONT_NUMBER_THAI_HOT, 
                "00:00", 
                Gfx.TEXT_JUSTIFY_CENTER );
        } else {       
            
            dc.drawText( _canvas_w * 0.50 ,(_canvas_h * 0.50) - (Gfx.getFontAscent(Gfx.FONT_NUMBER_THAI_HOT) / 2),
                Graphics.FONT_NUMBER_THAI_HOT, 
                "99:99", 
                Gfx.TEXT_JUSTIFY_CENTER );
        }
    }

    function ring() {
        if (Attention has :vibrate) {            
            Attention.vibrate(vibeData);
        }
    }

     // should be call each second
    function updateTime() {
        var msecleft = _countTimer.secondsLeft();
        if (msecleft > 1) {
            /*
            if (msecleft < 11) {
                ring();
            }*/
            if ((msecleft-1) % 30 == 0) {
                ring();
                
                if ((msecleft-1) % 60 == 0) {
                    ring();
                }
                
            }
            _countTimer.updateTimer();
        } else {
            //app.get().addLap();
            //raceStartTime = Time.now();
            _countTimer.endTimer();            
            ring();                    
            // TODO: maybe call on a timer ...
            // add a lap ?
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }
}
