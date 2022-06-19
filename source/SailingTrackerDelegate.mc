import Toybox.Lang;
import Toybox.WatchUi;

class SailingTrackerDelegate extends WatchUi.BehaviorDelegate {
    var mBoatmodel;

    function initialize(boat) {
        BehaviorDelegate.initialize();
        mBoatmodel = boat;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new SailingTrackerMenuDelegate(mBoatmodel), WatchUi.SLIDE_UP);
        return true;
    }

     // Handle the back action    
    function onBack() as Boolean {     
        System.println("SailingTrackerDelegate - onBack");
		// return false so that the InputDelegate method gets called. this will
        // allow us to know what kind of input cause the back behavior
        //return false;  // allow InputDelegate function to be called
        return true; // disable onBack
    }
    
     // Input handling of start/stop is mapped to onSelect
    // or click_tap touch
    // The onSelect() method should get called when you tap the screen of the vivoactive_hr. 
    // If onSelect returns false, then onTap should get called
    function onSelect() as Boolean {
        System.println("SailingTrackerDelegate - onSelect");  
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
        /*
        if (key.getKey() == WatchUi.KEY_ENTER) {            
            System.println("Key pressed: ENTER");            
            // Pass the input to the controller
        	mBoatmodel.StartStopRecording();
        	//WatchUi.pushView(new Rez.Menus.MainMenu(), new sailingMenuDelegate(), WatchUi.SLIDE_UP);
            return true;
        }*/

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
        return false; // let handle it !
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
    
    /*
	function onSwipe(evt) {
        var swipe = evt.getDirection();
    	//System.println("dlg: onSwipe : " + swipe);
    	
    	 var swipe = evt.getDirection();

        if (swipe == SWIPE_UP) {
            setActionString("SWIPE_UP");
        } else if (swipe == SWIPE_RIGHT) {
            setActionString("SWIPE_RIGHT");
        } else if (swipe == SWIPE_DOWN) {
            setActionString("SWIPE_DOWN");
        } else if (swipe == SWIPE_LEFT) {
            setActionString("SWIPE_LEFT");
        }
        
        return false;  // allow InputDelegate function to be called
    }
    
    // Screen Tap
    function onTap(evt) {
    	//System.println("dlg: onTap : " + evt.getType() );

        var now = System.getTimer();    
           
        if ((mStartedAt != 0) && ((now - mStartedAt) <= DOUBLETOUCH_MS)) {
            //detect double touch ? 
            //System.println("onTap - double touch");
            //mStartedAt = 0;
          
            // call controller
            mController.onDoubleTouch();
            mStartedAt = now;
            return true;
        } else {
            mController.onSelect();
            mStartedAt = now;
            return true;
        }
        mStartedAt = now;

        return false;  // allow InputDelegate function to be called
    }
    
    */

}