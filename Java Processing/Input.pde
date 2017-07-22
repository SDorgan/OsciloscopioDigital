import java.util.concurrent.Callable;
import java.util.logging.Logger;
import java.util.logging.Level;

// * ------------------ HOT KEYS ------------------
final char T_UP       = 'w'; // Translate waveform up
final char T_DOWN     = 's'; //                    down
final char T_LEFT     = 'a'; //                    left
final char T_RIGHT    = 'd'; //                    right
final char Z_IN       = 'c'; // Horizontal zoom in
final char Z_OUT      = 'z'; //                 out
final char S_IN       = 'e'; // Vertical scale in
final char S_OUT      = 'q'; //                out
final char MGL_UP     = 'r'; // Minor grid lines increase
final char MGL_DOWN   = 'f'; //                  decrease
final char TOG_PAUSE  = 'p'; // Toggle pause (unpause resets waveform)
final char RESET_AXIS = ' '; // Reset axis settings
final char MEAS_TIME  = 'x'; // Adds and/or highlights vertical bars (time measurement)
final char BAR_LEFT   = ','; // Move highlighted vertical bar left (can also mouse click)
final char BAR_RIGHT  = '.'; //                               right
// * ----------------------------------------------

enum Eevent
{
    KEY_PRESSED, KEY_RELEASED, MOUSE_PRESSED;
};

private final HashMap<Eevent, HashMap<Object, Callable>> registeredEventsTable = new HashMap();

void RegisterEvent(Eevent event, Object key, Callable callable)
{
	registeredEventsTable.get(event).put(key, callable);
}

void InputSetup()
{
    for(Eevent event : Eevent.values())
    {
    	registeredEventsTable.put(event, new HashMap());
    }

	RegisterEvent(Eevent.KEY_PRESSED, T_UP, new Callable(){public Object call(){control.CenterV_Up(); return null;}});
	RegisterEvent(Eevent.KEY_PRESSED, T_DOWN, new Callable(){public Object call(){control.CenterV_Down(); return null;}});
	RegisterEvent(Eevent.KEY_PRESSED, T_LEFT, new Callable(){public Object call(){control.CenterH_Left(); return null;}});
	RegisterEvent(Eevent.KEY_PRESSED, T_RIGHT, new Callable(){public Object call(){control.CenterH_Right(); return null;}});
    RegisterEvent(Eevent.KEY_PRESSED, MGL_UP, new Callable(){public Object call(){grid.IncGridResolution(); return null;}});
    RegisterEvent(Eevent.KEY_PRESSED, MGL_DOWN, new Callable(){public Object call(){grid.DecGridResolution(); return null;}});

	RegisterEvent(Eevent.KEY_RELEASED, Z_IN, new Callable(){public Object call(){control.ZoomIn(); return null;}});
	RegisterEvent(Eevent.KEY_RELEASED, Z_OUT, new Callable(){public Object call(){control.ZoomOut(); return null;}});
	RegisterEvent(Eevent.KEY_RELEASED, S_IN, new Callable(){public Object call(){control.ScaleUp(); return null;}});
	RegisterEvent(Eevent.KEY_RELEASED, S_OUT, new Callable(){public Object call(){control.ScaleDown(); return null;}});
	RegisterEvent(Eevent.KEY_RELEASED, TOG_PAUSE, new Callable(){public Object call(){control.TogglePause(); return null;}});
	RegisterEvent(Eevent.KEY_RELEASED, RESET_AXIS, new Callable(){public Object call(){control.ResetAxis(); return null;}});
}

// When a key is pressed down or held...
void keyPressed()
{
	Callable func = registeredEventsTable.get(Eevent.KEY_PRESSED).get(key);
	if (func != null)
		try {
			func.call();
		} catch (Exception e) {
    		Logger.getGlobal().log(Level.WARNING, null, e);
		}
	else
	{
		switch (key)
		{
			// Move the time bar left (also mouse click)
			case BAR_LEFT:
				if (timeMode == 1 && timeBars[0] > 0)
					timeBars[0] -= 1;
				else if (timeMode == 2 && timeBars[1] > 0)
					timeBars[1] -= 1; 
				break;

			//Move the time bar right (also mouse click)
			case BAR_RIGHT:
				if (timeMode == 1 && timeBars[0] < width - 1)
					timeBars[0] += 1;
				else if (timeMode == 2 && timeBars[1] < width - 1)
					timeBars[1] += 1; 
				break;

			default:
				break;
		}
	}
}

// When a key is released...
void keyReleased()
{
	Callable func = registeredEventsTable.get(Eevent.KEY_RELEASED).get(key);
	if (func != null)
		try {
			func.call();
		} catch (Exception e) {
			Logger.getGlobal().log(Level.WARNING, null, e);
		}
	else
	{
		switch (key)
		{
			case MEAS_TIME:
				timeMode = (timeMode + 1) % 3;
				break;

			default:
				break;
		}
	}
}

// Use mouse clicks to quickly move vertical bars (if highlighted)
void mousePressed()
{
	if (timeMode == 1)
		timeBars[0] = mouseX;
	else if(timeMode == 2)
		timeBars[1] = mouseX;
}