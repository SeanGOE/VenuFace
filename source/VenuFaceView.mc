import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time.Gregorian;

class VenuFaceView extends WatchUi.WatchFace {

    var width;


    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        width = dc.getWidth();
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }


    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min;
        var seconds = clockTime.sec;

        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        }

        drawDigitalData("$1$:$2$", [hours, clockTime.min.format("%02d")], "TimeLabel", Graphics.COLOR_LT_GRAY);
        drawDigitalData("$1$", [seconds], "TimeSeconds", Graphics.COLOR_LT_GRAY);


        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayNumber = today.day;
        var monthNumber = today.month;
        var year = today.year;
        drawDigitalData("$1$/$2$/$3$", [monthNumber, dayNumber, year], "DateLabel", Graphics.COLOR_LT_GRAY);
        

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        drawLineHand(dc, 12.00, hours, 60,  minutes, 80, 3);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		drawLineHand(dc, 60, minutes, 0, 0, 80 * 1.25, 3);
        
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        drawLineHand(dc, 60, seconds, 0, 0, 80 * 1.25, 3);

    }

    // Updates and displays the digital data on the watch face
    //      format - the string that determines the format of the data
    //      arraydata - an array contianing the data that is going to be displayed
    //      drawableId - the ID of the drawable text label
    //      color - the color in which the text will be displayed
    function drawDigitalData(format, arrayData, drawableId, color) {
        var string = Lang.format(format, arrayData);
        var drawable = View.findDrawableById(drawableId) as Text;
        drawable.setColor(color);
        drawable.setText(string);
    }

    // Draws a line representing a watch hand
    //      dc - the drawing context used to render objects
    //      num - the number of divisions around the clock for the specific hand
    //      time - the current time determining the hand's position
    //      offsetNum - the offset within the subdivision of the hand
    //      length - the length of the hand
    //      stroke - the thickness of the hand
    function drawLineHand(dc, num, time, offsetNum, offsetTime, length, stroke) {
			var angle = Math.toRadians((360/num) * time) - Math.PI/2;
			var center = width/2;
			

			if(offsetNum != 0) {
				var section = 360.00/num/offsetNum;
				angle += Math.toRadians(section * offsetTime);
			}
				
			dc.setPenWidth(stroke);

			var x2 = center + Math.round((Math.cos(angle) * length));
			var y2 = center + Math.round((Math.sin(angle) * length));


			dc.drawLine(center, center, x2, y2);
			
		}

    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }
}
