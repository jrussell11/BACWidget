using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;

class BACDetailView extends WatchUi.View {

	var labelCount; // label showing the number of drinks consumed
	
    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.EditorLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	labelCount = View.findDrawableById("id_drink_count");
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        var drinkSeries = Application.Storage.getValue("drinkSeries");
        labelCount.setText("Count: " + drinkSeries.size().toString());
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	labelCount = null;
    }
}

class BACDetailDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
   
    function onSelect() {
    	System.println("Select");
    }
    
    function onKey(key) {
    	System.println(key.getKey());
    	return true;
    }
    
    function onNextPage() {
    	removeDrink();
    	WatchUi.requestUpdate();
    }
    
    function onPreviousPage() {
    	addDrink();
    	WatchUi.requestUpdate();
    }
     
	function onBack() {
		System.println("Back");
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
    
    // Adds a new record for this instant
	function addDrink() {
		var drinkSeries = Application.Storage.getValue("drinkSeries");
		var now = Time.now().value();
		System.println(now.toString());
		drinkSeries.add(now);
		Application.Storage.setValue("drinkSeries", drinkSeries);
	}
	
	// Removes most recent drink
	// Relies on the fact that the series is kept sorted oldest-to-newest
	function removeDrink() {
		var drinkSeries = Application.Storage.getValue("drinkSeries");
		var l = drinkSeries.size();
		if (l == 0) {} //no-op
		else if (l == 1) {
			drinkSeries = [];
		}
		else {
			var o = drinkSeries[l - 1];
			drinkSeries.remove(o);
		}
		Application.Storage.setValue("drinkSeries", drinkSeries);
	}
}