/*
 *	Donchian Channel Example 1.mq4
 *	Copyright 2020, Orchard Forex
 *	https://orchardforex.com
 *
 */

/**=
 *
 * Disclaimer and Licence
 *
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * All trading involves risk. You should have received the risk warnings
 * and terms of use in the README.MD file distributed with this software.
 * See the README.MD file for more information and before using this software.
 *
 **/
#property copyright "Copyright 2020, Orchard Forex"
#property link "https://orchardforex.com"
#property version "1.00"
#property strict

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrGreen
#property indicator_color2 clrWhite
#property indicator_style1 STYLE_DOT
#property indicator_style2 STYLE_DOT
#property indicator_type1  DRAW_LINE
#property indicator_type2  DRAW_LINE

#include <Orchard/OOP/OOP1/DonchianChannel.mqh>

input int Periods = 20; // Periods in calculation

double    HiBuffer[];
double    LoBuffer[];

#define HiInd 0
#define LoInd 1

CciDonchianChannel *DonchianChannel;

int                 OnInit() {

   SetIndexBuffer( HiInd, HiBuffer );
   SetIndexLabel( HiInd, "High" );

   SetIndexBuffer( LoInd, LoBuffer );
   SetIndexLabel( LoInd, "Low" );

   DonchianChannel = new CciDonchianChannel( _Symbol, ( ENUM_TIMEFRAMES )_Period, Periods );

   return ( INIT_SUCCEEDED );
}

int OnCalculate( const int rates_total, const int prev_calculated, const datetime &time[],
                 const double &open[], const double &high[], const double &low[],
                 const double &close[], const long &tick_volume[], const long &volume[],
                 const int &spread[] ) {

   int limit = rates_total - prev_calculated;
   if ( prev_calculated > 0 ) limit++;

   for ( int i = limit - 1; i >= 0; i-- ) {
      HiBuffer[i] = DonchianChannel.High( i );
      LoBuffer[i] = DonchianChannel.Low( i );
   }

   return ( rates_total );
}
//+------------------------------------------------------------------+
