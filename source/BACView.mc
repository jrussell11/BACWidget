using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;

class BACView extends WatchUi.View {

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
    	var labelCount = View.findDrawableById("id_drink_count");
    	var drinkCount = countDrinks();
    	var label = "Count: " + drinkCount;
		labelCount.setText(label);
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
        
    // Load the drink series data, and count the records. Delete old records. 
    function countDrinks() {
        var drinkSeries = Application.Storage.getValue("drinkSeries");
        if (drinkSeries == null) {
        	// init app data
        	drinkSeries = [];
        }
    	if (drinkSeries.size() > 0) {
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
    	return drinkSeries.size();
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