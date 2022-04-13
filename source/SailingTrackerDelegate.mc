import Toybox.Lang;
import Toybox.WatchUi;

class SailingTrackerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new SailingTrackerMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}