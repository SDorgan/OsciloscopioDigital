import processing.serial.*;

private static final int BaudRate = 128000;

private Serial port;

public void SerialSetup()
{
	port = new Serial(this, Serial.list()[0], BaudRate);	// Com port specified here
//	port = new Serial(this, "/dev/ttyUSB0");				// Added by Santiago
}

private void Sync()
{
	int c;
	do
	{
    	c = port.read();
	}
	while (c != 0xff);
}

// Read value from serial stream
public int GetValue()
{
	if (port.available() < 3)
		return -1;

	Sync();
	int value = -1;
	if (port.available() > 1)
	{
		value = port.read() << 8;
		value |= port.read();
	}

	return value;
}