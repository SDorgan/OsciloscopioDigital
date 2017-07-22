
public class Control
{
	private int centerH;
	private int centerV;
	private float scale;
	private float zoom;
	private boolean pause;

	public Control()
	{
		this.centerH = 0;
		this.centerV = 0;
		this.scale = 0.5;
		this.zoom = 1.0;
		this.pause = false;
	}

	public int GetCenterH()
	{
		return this.centerH;
	}

	public int GetCenterV()
	{
		return this.centerV;
	}

	public float GetScale()
	{
		return this.scale;
	}

	public float GetZoom()
	{
	    return this.zoom;
	}

	public boolean GetPause()
	{
		return this.pause;
	}

	public void ResetAxis()
	{
		this.centerH = 0;
		this.centerV = 0;
		this.scale = 0.5;
		this.zoom  = 1;
	    grid.ResetGridResolution();
	}

	public void CenterH_Right()
	{
		this.centerH += 10 / this.scale;
	}

	public void CenterH_Left()
	{
		this.centerH -= 10 / this.scale;
	}

	public void CenterV_Up()
	{
		this.centerV -= 10 / this.scale;
	}

	public void CenterV_Down()
	{
		this.centerV += 10 / this.scale;
	}

	public void TogglePause()
	{
		if (this.pause)
		{
			centerH = 0;
			channel1.Clear();
			for (int i = 0; i < width; i++)
				times[i] = 0;
		}
		this.pause = !this.pause;
	}

	public void ZoomIn()
	{
		this.zoom *= 2.0f;
		if (((int)(width / this.zoom)) <= 1 )
			this.zoom /= 2.0f;
	}

	public void ZoomOut()
	{
		this.zoom /= 2.0f;
		if (this.zoom < 1.0f)
			this.zoom *= 2.0f;
	}

	public void ScaleUp()
	{
		this.scale *= 2;
	}

	public void ScaleDown()
	{
		this.scale /= 2;
	}
}