/*
 *	Donchian Channel Example 1.mq4
 *	Copyright 2020, Orchard Forex
 *	https://orchardforex.com
 *
 */

#property copyright "Copyright 2020, Orchard Forex"
#property link      "https://orchardforex.com"
#property version   "1.00"
#property strict

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1			clrGreen
#property indicator_color2			clrWhite
#property indicator_style1			STYLE_DOT
#property indicator_style2			STYLE_DOT
#property indicator_type1			DRAW_LINE
#property indicator_type2			DRAW_LINE

#include <Orchard/OOP/OOP1/DonchianChannel.mqh>

input    int   Periods=20; // Periods in calculation

double      HiBuffer[];
double      LoBuffer[];

#define     HiInd  0
#define     LoInd  1

CciDonchianChannel*	DonchianChannel;

int OnInit()
{

   SetIndexBuffer(HiInd, HiBuffer);
   SetIndexLabel(HiInd,"High");

   SetIndexBuffer(LoInd, LoBuffer);
   SetIndexLabel(LoInd,"Low");
   
   DonchianChannel	=	new CciDonchianChannel(_Symbol, (ENUM_TIMEFRAMES)_Period, Periods);

   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{

   int limit=rates_total-prev_calculated;
   if (prev_calculated>0)
      limit++;
   
   for (int i=limit-1; i>=0; i--)
   {
      HiBuffer[i]	= DonchianChannel.High(i);
      LoBuffer[i]	= DonchianChannel.Low(i);
   }
   
   return(rates_total);
}
//+------------------------------------------------------------------+
