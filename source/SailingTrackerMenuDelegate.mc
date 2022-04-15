import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SailingTrackerMenuDelegate extends WatchUi.MenuInputDelegate {
    var mBoatmodel;

    function initialize(boat) {
        MenuInputDelegate.initialize();
        mBoatmodel = boat;
    }

    function onMenuItem(item) 
    {
        if (item == :raceTimer)
        {
            System.println("race timer");
            //Ui.pushView(_raceTimerView, new RaceTimerViewDelegate(_raceTimerView), Ui.SLIDE_RIGHT);
        } /*
        else if (item == :cruiseView)
        {
            Ui.pushView(_cruiseView, new CruiseViewDelegate(_cruiseView, _gpsWrapper), Ui.SLIDE_RIGHT);
        } */
        else if (item == :windView)
        {
            System.println("wind");
            WatchUi.pushView(new SailingWindView(mBoatmodel) , new SailingWindDelegate(mBoatmodel), WatchUi.SLIDE_RIGHT);
        } /*        
        else if (item == :setting)
        {
            Ui.pushView(new Rez.Menus.SettingMenu(), new SettingMenuDelegate(_raceTimerView), Ui.SLIDE_LEFT);
        } */
        else if (item == :exitSave) 
        {
            System.println("exit save");
            mBoatmodel.save();
            //System.exit(); // cause IQ error
        } 
        else if (item == :exitDiscard) 
        {
            mBoatmodel.discard();            
            // pop to main
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            // pop to exit app
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            //System.exit(); // cause IQ error
        }   
    } 

}