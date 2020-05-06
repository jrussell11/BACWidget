using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.UserProfile;

class BACView extends WatchUi.View {

	var drinkSeries;
	var gender;
	var perDrink;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	initDrinkData();
    	var profile = UserProfile.getProfile();
    	gender = profile.gender;
    	if (gender == UserProfile.GENDER_FEMALE) {
        	perDrink = (0.806 * 1.2) / (0.49 * (profile.weight / 1000)); 
        } else {
        	perDrink = (0.806 * 1.2) / (0.58 * (profile.weight / 1000));
        }
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        var bac = estimateBAC();
    	var labelText = "BAC: " + bac.format("%0.3f");
    	var label = View.findDrawableById("bac");
		label.setText(labelText);
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	drinkSeries = null;
    	gender = null;
    	perDrink = null;
    }
    
    // load drinkSeries, and clean up old values
    function initDrinkData() {
       	drinkSeries = Application.Storage.getValue("drinkSeries");
        if (drinkSeries == null) {
        	// init app data
        	drinkSeries = [];
        }
        if (drinkSeries.size() > 0) {
	    	// remove old records
			var len = drinkSeries.size();
			var now = new Time.Moment(Time.now().value());
			var oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);
			var threshold = now.subtract(oneDay);
			for (var i = 0; i < len; i++) {
				var moment = new Time.Moment(drinkSeries[i]); // cast for comparison
				if (moment.lessThan(threshold)) {
					drinkSeries.remove(drinkSeries[i]);
					len -= 1;
				}
			}
		}
		Application.Storage.setValue("drinkSeries", drinkSeries);
    }
        
    // Load the drink series data, and estimate BAC. Delete old records. 
    function estimateBAC() {
    	var len = drinkSeries.size();
        if (len == 0) {
        	return 0;
        }
        
        var bac = 0; // accumulator
        var now = new Time.Moment(Time.now().value());
        
        for (var i = 0; i < len; i++) {
        	var c = 0;
        	var moment = new Time.Moment(drinkSeries[i]);
        	var dt = now.subtract(moment).value();
        	var hours = dt / 3600.0; // seconds per hour, as float to force fractional hours
        	if (gender == UserProfile.GENDER_FEMALE) {
        		c = (perDrink - (0.017 * hours)) * 10;
        	} else { // male
        		c = (perDrink - (0.015 * hours)) * 10;
        	}
        	if (c > 0) {
        		bac += c;
        	}
        }
        
        return bac;        
    }
}

class BACViewDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
   
    function onSelect() {
    	System.println("View::Select");
    	pushView(new BACDetailView(), new BACDetailDelegate(), WatchUi.SLIDE_LEFT);
    }    
}