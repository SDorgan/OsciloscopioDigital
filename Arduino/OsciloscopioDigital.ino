/*
 Name:		OsciloscopioDigital.ino
 Created:	19/06/2017 1:45:16
 Author:	Monty
*/

// adc clock division's values
#define PS_2 ((1 << ADPS0))
#define PS_4 ((1 << ADPS1))
#define PS_8 ((1 << ADPS1) | (1 << ADPS0))
#define PS_16 ((1 << ADPS2))
#define PS_32 ((1 << ADPS2) | (1 << ADPS0))
#define PS_64 ((1 << ADPS2) | (1 << ADPS1))
#define PS_128 ((1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0))

#define ANALOG_IN 3
#define DIGITAL_OUT 13
bool SIG_OUT = true;

void setup()
{
	Serial.begin(128000);

	// ~153kS/s max for each channel
	//	ADCSRA &= ~PS_128;
	//	ADCSRA |= PS_4;

	//	analogRead(A3);
	if(SIG_OUT)
	{
		pinMode(DIGITAL_OUT, OUTPUT);

		// initialize timer1 
		noInterrupts();				// disable all interrupts
		TCCR1A = 0;
		TCCR1B = 0;
		TCNT1  = 0;

		OCR1A = 31250;				// compare match register 16MHz/256/2Hz
		TCCR1B |= (1 << WGM12);		// CTC mode
		TCCR1B |= (1 << CS12);		// 256 prescaler 
		TIMSK1 |= (1 << OCIE1A);	// enable timer compare interrupt
		interrupts();				// enable all interrupts
	}
}

// Interrupt based
ISR(TIMER1_COMPA_vect)
{
	digitalWrite(DIGITAL_OUT, digitalRead(DIGITAL_OUT) ^ 1);   // Toggle
}

void WriteValue(short val)
{
	Serial.write( (val >> 8) & 0xff );
	Serial.write( val & 0xff );
}

void loop()
{
	short register value = analogRead(ANALOG_IN);
	Serial.write(0xff);
	WriteValue(value);
}

