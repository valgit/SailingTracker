import Toybox.Lang;
import Toybox.WatchUi;

class SailingTrackerDelegate extends WatchUi.BehaviorDelegate {
    var mBoatmodel;

    function initialize(boat) {
        BehaviorDelegate.initialize();
        mBoatmodel = boat;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new SailingTrackerMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

     // Handle the back action    
    function onBack() {     
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
    function onSelect() {
        System.println("SailingTrackerDelegate - onSelect");  
        return false; // allow InputDelegate function to be called
        //return true;
    }

	// Key pressed
    function onKey(key) {
    	//System.println("onKey : " + key);
    	/* maybe better ?
       	if (WatchUi.KEY_START == key || WatchUi.KEY_ENTER == key) {
            return onSelect();
        }
        */
        if (key.getKey() == WatchUi.KEY_ENTER) {            
            System.println("Key pressed: ENTER");            
            // Pass the input to the controller
        	mBoatmodel.StartStopRecording();
        	//WatchUi.pushView(new Rez.Menus.MainMenu(), new sailingMenuDelegate(), WatchUi.SLIDE_UP);
            return true;
        }
        // KEY_LAP KEY_START
        //System.println("Key pressed: " + key.getKey() );
        // next = 8
        // prev = 13
        return false; // allow InputDelegate function to be called
    }

    function onNextPage() {
        System.println("SailingTrackerDelegate - onNextPage");
        // handle it like simple touch
        //mController.onSelect();
        return false; // let handle it !
    }

    function onPreviousPage() {
        System.println("SailingTrackerDelegate -  onPreviousPage");
        return false;
    }

    // hold to reset timer
    function onHold(evt) {
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
    

}