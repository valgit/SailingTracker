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
    hidden var _cw2;
    hidden var _ch2;
    hidden var _timerValue = 0;

    hidden var _countTimer = null;    
    hidden var vibeData;

	function initialize(timer,boat) {
		View.initialize();
        
        // Get the model and controller from the Application
        mBoatmodel = boat;
        //mController = Application.getApp().controller;
        //App.getApp().getDefaultTimerCount();
        //_timerValue = Application.getApp().getProperty("defaultTimer");         
        _countTimer = timer; // new Countdown(_timerValue);
        _timerValue = _countTimer.getDefaultTimer();

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
        _cw2 = _canvas_w * 0.5;
        _canvas_h = dc.getHeight();      
        _ch2 = _canvas_h * 0.5;
    	    	
    }
    
    function formatTimer() {
        var secLeft = _countTimer.secondsLeft();

        var sec = secLeft % 60;
        var min = secLeft / 60;

        //format
        var countDownStr;
        if(min > 0) {
            countDownStr = min.format("%02d") + ":" + sec.format("%02d");
        }else {
            countDownStr = sec.format("%02d");
        }
        return countDownStr;
    }

	function onUpdate(dc as Dc) as Void {  
        
        dc.setColor(Gfx.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        // display current time  
        var clockTime = System.getClockTime();
        var curTime = clockTime.hour.format("%02d") + ":" + 
        clockTime.min.format("%02d") + ":" +
        clockTime.sec.format("%02d"); 
        dc.drawText(_canvas_w * 0.50 ,(_canvas_h * 0.25), Graphics.FONT_MEDIUM, curTime, Graphics.TEXT_JUSTIFY_CENTER);
        
        var strTime = formatTimer();
        if (_countTimer.isTimerRunning()) {
            updateTime();
            // show progress
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
            dc.drawText( _cw2 ,_ch2  - (Gfx.getFontAscent(Gfx.FONT_NUMBER_THAI_HOT) / 2),
                Graphics.FONT_NUMBER_THAI_HOT, 
                strTime, 
                Gfx.TEXT_JUSTIFY_CENTER );
            
        } else {
            // in race display the racing time
            if (_countTimer.isTimerComplete()) {
                strTime = mBoatmodel.getRaceTime();
                System.println("race time : " + strTime);
            }
            dc.drawText( _cw2 ,_ch2 - (Gfx.getFontAscent(Gfx.FONT_NUMBER_THAI_HOT) / 2),
                Graphics.FONT_NUMBER_THAI_HOT, 
                strTime, 
                Gfx.TEXT_JUSTIFY_CENTER );
        
        }
        drawCircle(dc);
    }

    function drawCircle(dc) {
        var handWidth = _canvas_w;
        var position = _countTimer.secondsLeft();
        var _r = _cw2 - (handWidth / 18);
        dc.setPenWidth(handWidth / 18);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        var end = (position * 360) / _timerValue; 
        //System.println("pos is : " + position + " end at : "+end);
        //dc.drawArc(handWidth / 6.2, handWidth / 2.47, handWidth / 10.5, 1, start + 90, end + 90);
        dc.drawArc(_cw2 ,_ch2, _r , Graphics.ARC_CLOCKWISE, 0, end );
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        dc.drawArc(_cw2 ,_ch2, _r  , Graphics.ARC_CLOCKWISE, end, 360 );        
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
            _countTimer.endTimer();            
            ring();                    
            // TODO: maybe call on a timer ...
            mBoatmodel.newRace();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }
}
