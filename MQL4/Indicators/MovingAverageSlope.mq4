//+------------------------------------------------------------------+
//|                                           MovingAverageSlope.mq4 |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Keisuke Iwabuchi"
#property link      "https://order-button.com/"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 clrDodgerBlue
#property indicator_width1 1
#property indicator_style1 0

input int slope_period = 1;  // 傾き算出の期間
input int ma_period    = 20; // 移動平均線の期間
input int ma_shift     = 0;  // 表示移動
input int ma_method    = 0;  // 計算方法{0:SMA,1:EMA,2:SMMA,3:LWMA}
input int ma_price     = 0;  // 計算価格{0:終値,1:始値,2:高値,3:安値,4:中央値,5:代表値,6:加重終値}

double slope[];

int OnInit()
{
   if(slope_period <= 0) {
      Alert("Invalid parameter value. slope_period");
      return(INIT_FAILED);
   }

   IndicatorBuffers(1);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, slope);
   SetIndexLabel(0, "MA Slope");
   IndicatorDigits(Digits);
   
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
   double ma1, ma2;
   int limit = Bars - IndicatorCounted();
   
   for(int i = limit - 1; i >= 0; i--){
      ma1 = iMA(_Symbol, 0, ma_period, ma_shift, ma_method, ma_price, i);
      ma2 = iMA(_Symbol, 0, ma_period, ma_shift, ma_method, ma_price, i + slope_period);
      slope[i] = (ma1 - ma2) / slope_period;
   }

   return(rates_total);
}
