import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Attention;

/*
 * handle  race timer
 * start should set
 * back : should go back !
 * maybe prev/next to adjust timer ?
 */
class countdownDelegate extends WatchUi.BehaviorDelegate {
    hidden var _countTimer;    

    function initialize(timer) {
        BehaviorDelegate.initialize();
        _countTimer = timer;
    }

    // no menu ?    
    /*
    function onMenu() as Boolean {
        System.println("countdownDelegate - onMenu");
        //WatchUi.pushView(new Rez.Menus.MainMenu(), new SailingTrackerMenuDelegate(_countTimer), WatchUi.SLIDE_UP);
        return false;
    }
    */
    
     // Handle the back action    
    function onBack() {     
        System.println("countdownDelegate - onBack");
        _countTimer.endTimer();
		// return false so that the InputDelegate method gets called. this will
        // allow us to know what kind of input cause the back behavior
        //return false;  // allow InputDelegate function to be called
        return false; 
    }
    
     // Input handling of start/stop is mapped to onSelect
    // or click_tap touch
    // The onSelect() method should get called when you tap the screen of the vivoactive_hr. 
    // If onSelect returns false, then onTap should get called
    function onSelect() {
        System.println("countdownDelegate - onSelect");  
        return false; // allow InputDelegate function to be called
        //return true;
    }

	// Key pressed
    function onKey(key) {
    	//System.println("onKey : " + key);    	

       	//if (WatchUi.KEY_START == key || WatchUi.KEY_ENTER == key) {
        if (key.getKey() == WatchUi.KEY_ENTER || WatchUi.KEY_START == key.getKey() ) {
            // Pass the input to the controller
            if (_countTimer.isTimerRunning()) {
                _countTimer.endTimer();
            } else {                
                System.println("start counter");
                _countTimer.startTimer();
            }
            
            if (Attention has :vibrate) {
                var vibe = [new Attention.VibeProfile(  50, 100 )];
                Attention.vibrate(vibe);
            }	                	
            
            return true; // we handle it !
        }

        // KEY_LAP KEY_START
        //System.println("Key pressed: " + key.getKey() );
        // next = 8
        // prev = 13
        return false; // allow InputDelegate function to be called
    }

    function onNextPage() {
        System.println("countdownDelegate - onNextPage");
        _countTimer.fixTimeUp();
        // handle it like simple touch
        //mController.onSelect();
        return true; // let handle it !
    }

    function onPreviousPage() {
        System.println("countdownDelegate -  onPreviousPage");
        _countTimer.fixTimeDown();
        return true;
    }

    // hold to reset timer
    function onHold(evt) {
		System.println("countdownDelegate - onHold");
        _countTimer.resetTimer();		
        return false;
    }
    

}