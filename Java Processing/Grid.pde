public class Grid extends Canvas
{
    public color boundsColor;
    public color minorGridColor;
//	private int lines;
	private Control control;
	private final float[] VScale = {5, 2, 1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01};
	private int scaleIndex;

	public Grid(int x, int y, int width, int height, Control control)
	{
    	super(x, y, width, height);
//	    this.lines = 0;
		this.scaleIndex = 0;
		this.control = control;
		this.boundsColor = color(255, 0, 0);
		this.minorGridColor = color(75, 75, 75);
	}

	public void IncGridResolution()
	{
    	if (this.scaleIndex < (this.VScale.length - 1))
    		this.scaleIndex++;
	}

	public void DecGridResolution()
	{
		if (this.scaleIndex > 0)
			this.scaleIndex--;
	}

	public void ResetGridResolution()
	{
		this.scaleIndex = 0;
	}

	private void DrawBounds()
	{
		// Get scaled values for bounds
		int pFive = getY(1023, this.GetHeight());
		int zero = getY(0, this.GetHeight());

		// Draw voltage bounds
		stroke(this.boundsColor);
		this.DrawLine(0, pFive - 1, this.GetWidth(), pFive - 1);
		this.DrawLine(0, zero + 1, this.GetWidth(), zero + 1);

		// Add voltage bound text
		textFont(f, 10);
		fill(this.boundsColor);
		this.DrawText("+5V", 5, pFive + 12);
		this.DrawText(" 0V", 5, zero - 4);
	}


	private final String[] timeScaleString = {"ns", "us", "ms", "s"};
	private final float[] timeScaleMultipliers = {1.0e0, 1.0e-3, 1.0e-6, 1.0e-9};

	private int GetPreferredTimeScale(float valueIn)
	{
    	int index = 0;
    	for (; index < (timeScaleString.length - 1); index++)
    	{
        	if (valueIn < 1000)
        		break;

        	valueIn /= 1000;
    	}

    	return index;
	}

	private void DrawVerticalBars()
	{
        if (timeMode > 0)
        {
            textFont(f, 16);
            fill(204, 102, 0);

            int idx0 = round(this.GetWidth() + (timeBars[0] - this.GetWidth() - control.GetCenterH()) / control.GetZoom());
            int idx1 = round(this.GetWidth() + (timeBars[1] - this.GetWidth() - control.GetCenterH()) / control.GetZoom());

            // Ensure time bars are over a recorded portion of the waveform
            if (!this.PointInLine(idx0, 0, this.GetWidth() - 1)
                || !this.PointInLine(idx1, 0, this.GetWidth() - 1)
                || (times[idx1] == 0) || (times[idx0] == 0))
            {
                this.DrawText("Time: N/A", 30, this.GetHeight() - 12);
            }
            else
            {
                float timeDiff = truncate(times[idx1] - times[idx0], 2);
                int index = this.GetPreferredTimeScale(timeDiff);
                this.DrawText("Time: " + (14.5 * timeDiff * this.timeScaleMultipliers[index]) + " " + this.timeScaleString[index], 30, this.GetHeight() - 12);
            }
        }
	}

	// Draw gridlines (bounds, minor)
	public void Render()
	{
		DrawBounds();

		// Draw minor grid lines
		int gridVal = 0;
		stroke(75, 75, 75);
		int lines = (int) (5.0 / this.VScale[this.scaleIndex]) - 1;
		for (int i = 0; i < lines; i++)
		{
			gridVal = getY(round((i + 1.0) * (1023.0 / (lines + 1.0))), this.GetHeight());
			this.DrawLine(0, gridVal, this.GetWidth(), gridVal);
		}

		// Add minor grid line text
		if (this.scaleIndex > 0)
		{
			textFont(f, 16);
			fill(204, 102, 0);
			float scaleVal = truncate(5.0f / (lines + 1), 3);
			this.DrawText("Grid: " + scaleVal + "V", 1170, this.GetHeight() - 12);
		}

		this.DrawVerticalBars();
	}
}