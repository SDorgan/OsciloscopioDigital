// Global vars
Channel channel1;
long[] times;
int timeMode = 0;
int[] timeBars = {0, 0};
Control control;

void setup()
{
	// window size
	size(1280, 480);
	RenderSetup();
	SerialSetup();
	control = new Control();
    channel1 = new Channel(width);
    grid = new Grid(0, 0, width, height, control);
	times = new long[width];
	timeBars[0] = width / 3;
	timeBars[1] = 2 * width / 3;
    InputSetup();
}