public class Canvas
{
	private int x;
	private int y;
	private int width;
	private int height;

	public Canvas(int x, int y, int width, int height)
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	public void SetX(int value)
	{
		this.x = value;
	}

	public void SetY(int value)
	{
		this.y = value;
	}

	public int GetWidth()
	{
		return this.width;
	}

	public void SetWidth(int value)
	{
		this.width = value;
	}

	public int GetHeight()
	{
		return this.height;
	}

	public void SetHeight(int value)
	{
		this.height = value;
	}

	public void DrawLine(int startX, int startY, int endX, int endY)
	{
		line(this.x + startX, this.y + startY, this.x + endX, this.y + endY);
	}

	public void DrawText(String data, int x, int y)
	{
		text(data, this.x + x, this.y + y);
	}

    protected boolean PointInLine(int value, int min, int max)
	{
		return ((value >= min) && (value <= max));
	}
}