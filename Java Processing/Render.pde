private PFont f;
private long elapsedTime = 0;
private Grid grid;

void RenderSetup()
{
	f = createFont("Arial", 16, true);
	smooth();
}

// Get a y-value for the datapoint, varies based on axis settings
int getY(int val, int height)
{
	return (int)((height / 2) - (val - 512 + control.GetCenterV()) * control.GetScale() / 1023.0f * (height - 1));
}

// Truncate a floating point number
float truncate(float x, int digits)
{
	float temp = pow(10.0, digits);
	return round( x * temp ) / temp;
}

// Draw vertical 'time bars' (seperate from above for better layering)
void drawVertLines()
{
	stroke(75, 75, 75);
	if (timeMode == 1)
	{
		line(timeBars[1], 0, timeBars[1], height);
		stroke(100, 100, 255);
		line(timeBars[0], 0, timeBars[0], height);
	}
	else if (timeMode == 2)
	{
		line(timeBars[0], 0, timeBars[0], height);
		stroke(100, 255, 100);
		line(timeBars[1], 0, timeBars[1], height);
	}
}

// Draw waveform
void DrawChannel(Channel channel)
{
    int x0 = 0, x1 = 0, y0 = 0, y1 = 0;
    stroke(255,255,0);
    for (int i = 0; i < width; i++)
    {
        x1 = round(width - ((width-i) * control.GetZoom()) + control.GetCenterH());
        y1 = getY(channel.GetValue(i), height);
        if (i > 1)
	        line(x0, y0, x1, y1);
        x0 = x1;
        y0 = y1;
    }
}

// Push the timestamps in the time array
void pushTime(long time)
{
    for (int i = 0; i < width - 1; i++)
        times[i] = times[i + 1];
    times[width - 1] = time;
}

// Primary drawing function
void draw()
{
	background(0);
	grid.Render();

//	int valTime = GetValue();
	int val = GetValue();
    long valTime = System.nanoTime();

	// If not paused
	if (!control.GetPause())
	{
		if ((valTime != -1) && (val != -1))
		{
			// Push value/time onto array
			channel1.AddValue(val);
			
//			elapsedTime += valTime;
			elapsedTime = valTime / 1000;
			pushTime(elapsedTime);

			// Print current voltage reading
			textFont(f, 16);
			fill(204, 102, 0);
			float voltage = truncate(5.0 * val / 1023, 2);
			text("Voltage: " + voltage + "V", 1170, 30);
			text("Value read: " + val, 1170, 50);
			text("Elapsed time: " + elapsedTime + " us", 1070, 70);
		}
	}

	DrawChannel(channel1);
	drawVertLines();
}