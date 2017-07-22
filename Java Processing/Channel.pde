import processing.data.IntList;

public class Channel
{
	private final IntList data;
	private final int maxSize;

	public Channel(int size)
	{
        this.data = new IntList();
    	this.maxSize = size;
	}

	public int GetValue(int index)
	{
    	if (index >= this.data.size())
    		return 0;

		return this.data.get(index);
	}

	public void AddValue(int value)
	{
        this.data.append(value);
		if (this.data.size() > this.maxSize)
		    this.data.remove(0);
	}

	public void Clear()
	{
    	this.data.clear();
	}
}