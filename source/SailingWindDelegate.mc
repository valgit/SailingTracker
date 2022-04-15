import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Attention;

/*
 * handle setting TWD
 * start should set
 * back : should go back !
 * maybe prev/next to adjust
 */
class SailingWindDelegate extends WatchUi.BehaviorDelegate {
    hidden var mBoatmodel;
    hidden var TWD = 0.0; // true wind angle

    function initialize(boat) {
        BehaviorDelegate.initialize();
        mBoatmodel = boat;
    }

    // no menu ?    
    function onMenu() as Boolean {

        //WatchUi.pushView(new Rez.Menus.MainMenu(), new SailingTrackerMenuDelegate(mBoatmodel), WatchUi.SLIDE_UP);
        return true;
    }

     // Handle the back action    
    function onBack() {     
        //System.println("SailingWindDelegate - onBack");
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
        System.println("SailingWindDelegate - onSelect");  
        return false; // allow InputDelegate function to be called
        //return true;
    }

	// Key pressed
    function onKey(key) {
    	//System.println("onKey : " + key);    	

       	//if (WatchUi.KEY_START == key || WatchUi.KEY_ENTER == key) {
        if (key.getKey() == WatchUi.KEY_ENTER || WatchUi.KEY_START == key.getKey() ) {
            // Pass the input to the controller
            System.println("set wind dir");
            var actInfo = Sensor.getInfo();	        

	        if (actInfo has :heading)  {
		        var heading_deg = actInfo.heading * 180 / Math.PI;
                System.println("TWD : "+ heading_deg);
                mBoatmodel.setWind(heading_deg);
                if (Attention has :vibrate) {
                    var vibe = [new Attention.VibeProfile(  50, 100 )];
                    Attention.vibrate(vibe);
                }
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
        System.println("SailingWindDelegate - onNextPage");
        // handle it like simple touch
        //mController.onSelect();
        return false; // let handle it !
    }

    function onPreviousPage() {
        System.println("SailingWindDelegate -  onPreviousPage");
        return false;
    }

    // hold to reset timer
    function onHold(evt) {
		System.println("SailingWindDelegate - onHold");
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