/*
 *	CciDonchianChannel.mqh
 *	Copyright 2013-2020, Orchard Forex
 * https://orchardforex.com
 *
 */

#property copyright "Copyright 2013-2020, Orchard Forex"
#property link      "https://orchardforex.com"
#property version   "1.00"
#property strict

class CciDonchianChannel {

private:

	string					mSymbol;
	ENUM_TIMEFRAMES		mTimeframe;
	int						mBarCount;
	
	datetime					mFirstBarTime;
	
	double					mChannelHigh[];
	double					mChannelLow[];
	
	int						mPrevCalculated;

	void	Update();


public:

	CciDonchianChannel();
	CciDonchianChannel(string symbol, ENUM_TIMEFRAMES timeframe, int barCount);
	~CciDonchianChannel();
	
	void	Init(string symbol, ENUM_TIMEFRAMES timeframe, int barCount);

	double	High(int index);
	double	Low(int index);

};

CciDonchianChannel::CciDonchianChannel() {

//	Default values
//	barCount=20

	Init(_Symbol, (ENUM_TIMEFRAMES)_Period, 20);

}

CciDonchianChannel::CciDonchianChannel(string symbol, ENUM_TIMEFRAMES timeframe, int barCount) {

	Init(symbol, timeframe, barCount);
	
}

CciDonchianChannel::~CciDonchianChannel() {

}

void		CciDonchianChannel::Init(string symbol, ENUM_TIMEFRAMES timeframe, int barCount) {
	
	mSymbol				=	symbol;
	mTimeframe			=	timeframe;
	mBarCount			=	barCount;
	
	mFirstBarTime		=	0;
	mPrevCalculated	=	0;
	
	ArraySetAsSeries(mChannelHigh, true);
	ArraySetAsSeries(mChannelLow, true);
	
	Update();
	
}

double	CciDonchianChannel::High(int index) {

	Update();

	if (index>=ArraySize(mChannelHigh))	return(0);
	return(mChannelHigh[index]);
	
}

double	CciDonchianChannel::Low(int index) {

	Update();

	if (index>=ArraySize(mChannelLow))	return(0);
	return(mChannelLow[index]);
	
}




//
//	This is the function definition for an indicator
//
/*
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {
*/
void		CciDonchianChannel::Update() {

	//	Some basic information required
	int		bars				=	iBars(mSymbol, mTimeframe);			//	How many bars are available to calculate
	datetime	firstBarTime	=	iTime(mSymbol, mTimeframe, bars-1);	//	Find the time of the first available bar
	
	//	How many bars must be calculated
   int		limit				=	bars-mPrevCalculated;					//	How many bars have we NOT calculated
   if (mPrevCalculated>0)		limit++;										//	This forces recalculation of the current bar (0)
	if (firstBarTime!=mFirstBarTime) {
		limit						=	bars;											//	First time change means recalculate everything
		mFirstBarTime			=	firstBarTime;								//	Just a reset
	}

	if (limit<=0)							return;								//	Should not happen but better to be safe
		
	if (bars!=ArraySize(mChannelHigh)) {									//	Make sure array size matches number of bars
		ArrayResize(mChannelHigh, bars);
		ArrayResize(mChannelLow, bars);
	}
	
	int	lim	=	0;
	for (int i = limit-1; i>=0; i--) {
		lim		=	(bars-i)>=mBarCount ? mBarCount : (bars-i);		//	To handle bars before the length of the channel
		mChannelHigh[i]	=	iHigh(mSymbol, mTimeframe, iHighest(mSymbol, mTimeframe, MODE_HIGH, lim, i));
		mChannelLow[i]		=	iLow(mSymbol, mTimeframe, iLowest(mSymbol, mTimeframe, MODE_LOW, lim, i));
	}
	
	mPrevCalculated		=	bars;																		//	Reset our position in the array
	
}
