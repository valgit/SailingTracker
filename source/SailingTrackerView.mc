import Toybox.Graphics;
import Toybox.WatchUi;

class SailingTrackerView extends CompassView {

    function initialize() {
        CompassView.initialize();
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
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        CompassView.onHide();
    }

}
