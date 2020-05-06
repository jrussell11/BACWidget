# BACWidget
Widget for Garmin watches to record alcohol consumption and estimate blood alcohol content. The estimate is based on (the Widmark formula)[https://en.wikipedia.org/wiki/Blood_alcohol_content#Estimation_by_intake] using the user's configured weight and gender. Records are discarded after 24 hours, so this isn't approprite for tracking your multi-day binges. 

# Usage
Viewing the widget will estimate BAC based on already-entered data. 

Pressing [Select] will allow you to record consumption. Doing so changest the displays to the total number of drinks consumed in the past 24 hours. 

In this mode:
* Pressing [Up] records the instantaneous consumption of one standard drink at that moment in time. 
* Pressing [Down] removes the most recently recorded drink, in case it was added by mistake. 
* [Back] returns to the widget list, and an updated calculation of your BAC. 

# TODO 
* Change detail page from count of records to the record timestamps;
* Revise calculation to reflect time for alcohol to pass in to bloodstream;
* Show "+" and "-" bitmaps by the [Up] and [Down] buttons, as a guide to the user;
* Calculate time-to-sober;
* Change BAC display from instantaneous value to a graph from earliest to time-to-sober;
