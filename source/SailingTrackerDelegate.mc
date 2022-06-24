import Toybox.Lang;
import Toybox.WatchUi;

class SailingTrackerDelegate extends WatchUi.BehaviorDelegate {
    var mBoatmodel;

    // for double touch ? (in ms)
    hidden const DOUBLETOUCH_MS = 250;
    hidden var mStartedAt;

    function initialize(boat) {
        BehaviorDelegate.initialize();
        mBoatmodel = boat;

        mStartedAt = 0;    
    }

    function onMenu() as Boolean {
        //System.println("SailingTrackerDelegate - onMenu");
        WatchUi.pushView(new Rez.Menus.MainMenu(), new SailingTrackerMenuDelegate(mBoatmodel), WatchUi.SLIDE_UP);
        return true;
    }

     // Handle the back action    
    function onBack() as Boolean {     
        System.println("SailingTrackerDelegate - onBack");
		// return false so that the InputDelegate method gets called. this will
        // allow us to know what kind of input cause the back behavior
        //return false;  // allow InputDelegate function to be called
        mBoatmodel.newRace();
        return true; // disable onBack, we have handle it !
    }
    
     // Input handling of start/stop is mapped to onSelect
    // or click_tap touch
    // The onSelect() method should get called when you tap the screen of the vivoactive_hr. 
    // If onSelect returns false, then onTap should get called
    function onSelect() as Boolean {
        System.println("SailingTrackerDelegate - onSelect");  
        // for now create a new/end lap
        mBoatmodel.newRace();
        return false; // allow InputDelegate function to be called
        //return true;
    }

	// Key pressed
    function onKey(key) as Boolean {
    	//System.println("onKey : " + key);    	

       	//if (WatchUi.KEY_START == key || WatchUi.KEY_ENTER == key) {
        if (key.getKey() == WatchUi.KEY_ENTER || WatchUi.KEY_START == key.getKey() ) {
            // Pass the input to the controller
        	mBoatmodel.StartStopRecording();
            //return onSelect();
            return true; // we handle it !
        }        

        // KEY_LAP KEY_START
        //System.println("Key pressed: " + key.getKey() );
        // next = 8
        // prev = 13
        return false; // allow InputDelegate function to be called
    }

    function onNextPage() as Boolean {
        System.println("SailingTrackerDelegate - onNextPage");
        // handle it like simple touch
        //mController.onSelect();
        // push countdownView
        //TODO: checlk memory usage ?
        var _timerValue = Application.getApp().getProperty("defaultTimer");         
        var _countTimer = new Countdown(_timerValue); //TODO: memory handling ?
        WatchUi.pushView(new countdownView(_countTimer,mBoatmodel), new countdownDelegate(_countTimer), WatchUi.SLIDE_DOWN);
        //return false; // let handle it !
        return true; // we handle it !
    }

    function onPreviousPage() as Boolean {
        System.println("SailingTrackerDelegate -  onPreviousPage");
        return false;
    }

    // hold to reset timer
    function onHold(evt) as Boolean {
		System.println("SailingTrackerDelegate - onHold");
		/*
        if (Attention has :vibrate) {
        	var vibe = [new Attention.VibeProfile(  50, 100 )];
       	 	Attention.vibrate(vibe);
       	}
        //TODO: resetTimer();
        return true;
        */
        return false;
    }
    
    function onDoubleTouch() as Boolean {
        System.println("SailingTrackerDelegate -  onDoubleTouch");
        return false;
    }

    /*
	function onSwipe(evt) {
        var swipe = evt.getDirection();
    	//System.println("dlg: onSwipe : " + swipe);
    	
    	//var swipe = evt.getDirection();

        if (swipe == SWIPE_UP) {
            System.println("SWIPE_UP");
        } else if (swipe == SWIPE_RIGHT) {
            System.println("SWIPE_RIGHT");
        } else if (swipe == SWIPE_DOWN) {
            System.println("SWIPE_DOWN");
        } else if (swipe == SWIPE_LEFT) {
            System.println("SWIPE_LEFT");
        }
        
        return false;  // allow InputDelegate function to be called
    }
*/
    /*
    // Screen Tap
    function onTap(evt) {
    	//System.println("dlg: onTap : " + evt.getType() );
        System.println("SailingTrackerDelegate - onTap");

        var now = System.getTimer();    
           
        if ((mStartedAt != 0) && ((now - mStartedAt) <= DOUBLETOUCH_MS)) {
            //detect double touch ? 
            //System.println("onTap - double touch");
            //mStartedAt = 0;
          
            // call controller
            onDoubleTouch();
            mStartedAt = now;
            return true;
        }  else {
            onSelect();
            mStartedAt = now;
            return true;
        }
        mStartedAt = now;

        return false;  // allow InputDelegate function to be called
    }
    
*/
}