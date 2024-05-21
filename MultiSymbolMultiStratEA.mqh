//+------------------------------------------------------------------+
//   Daily Counter Trend + Keltner Channels.mq5 
//   Copyright 2024, Alpha Forge Technologies 
//   antaresinvestors@gmail.com
//+------------------------------------------------------------------+

#property strict
#define app_copyright "Copyright 2024, Alpha Forge Technologies"
#define app_link      "https://www.mql5.com"
#define app_version   "1.00"

#include <Trade/Trade.mqh>
#include <Risk_Management.mqh>
#include <Trade_Manager.mqh>

#define strat1_NumOfSymbols 4
#define strat2_NumOfSymbols 3

CTrade *strat1_Trade;
CTrade *strat2_Trade;

//=========================STRAT 1 VARIABLES (KELTNER CHANNELS)=========================                                

//-----INPUT VARIABLES-----

input bool strat1_inputUseBreakEven = true;                        // Strategy 1: Move stop loss to break even? 
input int strat1_inputWhenToBreak = 95;                            // Strategy 1: When to break even in pips
input int strat1_inputBreakBy = 25;                                // Strategy 1: Break even by how many pips? 

input bool strat1_inputUseTrailingStops = true;                    // Strategy 1: Use trailing stop? 
input int strat1_inputWhenToTrail = 100;                           // Strategy 1: When to start trailing
input int strat1_inputTrailBy = 75;                                // Strategy 1: Trailing stop pips               

// Balance Management inputs
input bool strat1_UseMoneyManagement = true;
input ENUM_FUNDS_TYPE strat1_inputFundsToUse = UseEquity;          // Strategy 1: Funds to use for lot calculation
input ENUM_MM strat1_inputMMType = Use_ATR_MM;                     // Strategy 1: Type of money management
input double strat1_inputATRMultiplier = 1;                        // Strategy 1: ATR multiplier
input double strat1_inputFixedBalance = 1000;                      // Strategy 1: Amount of balance to be used if Fixed Balance is chosen for FundsToUse
input double strat1_inputFixedRiskMoney = 20;                      // Strategy 1: Fixed risk money
input double strat1_inputRiskPct = 5;                              // Strategy 1: Percentage of funds to risk

// Standard EA features
input int strat1_MagicNum = 1234;                                  // Strategy 1: Magic number
input double strat1_inputLotSize = 0.05;                           // Strategy 1: Lot size
input int strat1_inputSlippage = 50;                               // Strategy 1: Slippage in points
input string strat1_TradeComment = "MS KCC";                       // Strategy 1: strat1_Trade Comment

//-----FIRST SYMBOL INPUTS-----
input bool strat1_AllowSymbol1 = true;                             // Strategy 1 - Enable First Symbol?
input string strat1_inputS1_Symbol = "EURUSD";                     // Strategy 1:  First Symbol
input ENUM_TIMEFRAMES strat1_inputS1_TradeTF = PERIOD_M15;         // Strategy 1, First Symbol: Timeframe we will be trading in 

input int strat1_inputS1_MAPeriod1 = 15;                           // Strategy 1, First Symbol: MA Period 1
input int strat1_inputS1_MAPeriod2 = 45;                           // Strategy 1, First Symbol: MA Period 2

input int strat1_inputS1_StopLossPips = 10;                        // Strategy 1, First Symbol: Stop loss pips
input int strat1_inputS1_TakeprofitPips = 15;                      // Strategy 1, First Symbol: Take profit pips

input int strat1_inputS1_WhenToBreakEven = 10;                     // Strategy 1, First Symbol: When to break even in pips
input int strat1_inputS1_BreakBy = 5;                              // Strategy 1, First Symbol: Break even by how many pips? 

input int strat1_inputS1_WhenToTrail = 7;                          // Strategy 1, First Symbol: When to start trailing
input int strat1_inputS1_TrailBy = 15;                             // Strategy 1, First Symbol: Trailing stop pips

//-----SECOND SYMBOL INPUTS-----
input bool strat1_AllowSymbol2 = true;                             // Strategy 1 - Enable Second Symbol?
input string strat1_inputS2_Symbol = "USDJPY";                     // Strategy 1, Second Symbol: Second Symbol
input ENUM_TIMEFRAMES strat1_inputS2_TradeTF = PERIOD_M15;         // Strategy 1, Second Symbol: Timeframe we will be trading in 

input int strat1_inputS2_MAPeriod1 = 15;                           // Strategy 1, Second Symbol: MA Period 1
input int strat1_inputS2_MAPeriod2 = 45;                           // Strategy 1, Second Symbol: MA Period 2

input int strat1_inputS2_StopLossPips = 10;                        // Strategy 1, Second Symbol: Stop loss pips
input int strat1_inputS2_TakeprofitPips = 15;                      // Strategy 1, Second Symbol: Take profit pips

input int strat1_inputS2_WhenToBreakEven = 10;                     // Strategy 1, Second Symbol: When to break even in pips
input int strat1_inputS2_BreakBy = 5;                              // Strategy 1, Second Symbol: Break even by how many pips? 

input int strat1_inputS2_WhenToTrail = 7;                          // Strategy 1, Second Symbol: When to start trailing
input int strat1_inputS2_TrailBy = 15;                             // Strategy 1, Second Symbol: Trailing stop pips

//-----THIRD SYMBOL INPUTS-----
input bool strat1_AllowSymbol3 = true;                             // Strategy 1 - Enable Third Symbol?
input string strat1_inputS3_Symbol = "GBPUSD";                     // Strategy 1 Third Symbol
input ENUM_TIMEFRAMES strat1_inputS3_TradeTF = PERIOD_M15;         // Strategy 1 Third Symbol: Timeframe we will be trading in 

input int strat1_inputS3_MAPeriod1 = 15;                           // Strategy 1 Third Symbol: MA Period 1
input int strat1_inputS3_MAPeriod2 = 45;                           // Strategy 1 Third Symbol: MA Period 2

input int strat1_inputS3_StopLossPips = 10;                        // Strategy 1 Third Symbol: Stop loss pips
input int strat1_inputS3_TakeprofitPips = 15;                      // Strategy 1 Third Symbol: Take profit pips

input int strat1_inputS3_WhenToBreakEven = 10;                     // Strategy 1 Third Symbol: When to break even in pips
input int strat1_inputS3_BreakBy = 5;                              // Strategy 1 Third Symbol: Break even by how many pips? 

input int strat1_inputS3_WhenToTrail = 7;                          // Strategy 1 Third Symbol: When to start trailing
input int strat1_inputS3_TrailBy = 15;                             // Strategy 1 Third Symbol: Trailing stop pips

//-----FOURTH SYMBOL INPUTS-----
input bool strat1_AllowSymbol4 = true;                             // Strategy 1 - Enable Fourth Symbol?
input string strat1_inputS4_Symbol = "AUDUSD";                     // Strategy 1 Fourth Symbol
input ENUM_TIMEFRAMES strat1_inputS4_TradeTF = PERIOD_M15;         // Strategy 1 Fourth Symbol: StratTimeframe we will be trading in 

input int strat1_inputS4_MAPeriod1 = 15;                           // Strategy 1 Fourth Symbol: MA Period 1
input int strat1_inputS4_MAPeriod2 = 45;                           // Strategy 1 Fourth Symbol: MA Period 2

input int strat1_inputS4_StopLossPips = 10;                        // Strategy 1 Fourth Symbol: Stop loss pips
input int strat1_inputS4_TakeprofitPips = 15;                      // Strategy 1 Fourth Symbol: Take profit pips

input int strat1_inputS4_WhenToBreakEven = 10;                     // Strategy 1 Fourth Symbol: When to break even in pips
input int strat1_inputS4_BreakBy = 5;                              // Strategy 1 Fourth Symbol: Break even by how many pips? 

input int strat1_inputS4_WhenToTrail = 7;                          // Strategy 1 Fourth Symbol: When to start trailing
input int strat1_inputS4_TrailBy = 15;                             // Strategy 1 Fourth Symbol: Trailing stop pips

//-----GLOBAL VARIABLES-----

// EA Variables
double strat1_StopLossPips[strat1_NumOfSymbols], strat1_TakeProfitPips[strat1_NumOfSymbols]; 

ulong strat1_LastBars[strat1_NumOfSymbols];

double strat1_CurrentBid[strat1_NumOfSymbols], strat1_CurrentAsk[strat1_NumOfSymbols];

// Storing symbol metrics into arrays
string strat1_Symbols[strat1_NumOfSymbols] = {strat1_inputS1_Symbol, strat1_inputS2_Symbol, strat1_inputS3_Symbol, strat1_inputS4_Symbol};
bool strat1_InputAllowSymbols[strat1_NumOfSymbols] = {strat1_AllowSymbol1, strat1_AllowSymbol2, strat1_AllowSymbol3, strat1_AllowSymbol4};

ENUM_TIMEFRAMES strat1_InputTradingTF[strat1_NumOfSymbols] = {strat1_inputS1_TradeTF, strat1_inputS2_TradeTF, strat1_inputS3_TradeTF, strat1_inputS4_TradeTF};
int strat1_InputMAPeriod1[strat1_NumOfSymbols] = {strat1_inputS1_MAPeriod1, strat1_inputS2_MAPeriod1, strat1_inputS3_MAPeriod1, strat1_inputS4_MAPeriod1};
int strat1_InputMAPeriod2[strat1_NumOfSymbols] = {strat1_inputS1_MAPeriod2, strat1_inputS2_MAPeriod2, strat1_inputS3_MAPeriod2, strat1_inputS4_MAPeriod2};

int strat1_InputStopLossPips[strat1_NumOfSymbols] = {strat1_inputS1_StopLossPips, strat1_inputS2_StopLossPips, strat1_inputS3_StopLossPips, strat1_inputS4_StopLossPips};
int strat1_InputTakeProfitPips[strat1_NumOfSymbols] = {strat1_inputS1_TakeprofitPips, strat1_inputS2_TakeprofitPips, strat1_inputS3_TakeprofitPips, strat1_inputS4_TakeprofitPips};
int strat1_InputWhenToBreakEven[strat1_NumOfSymbols] = {strat1_inputS1_WhenToBreakEven, strat1_inputS2_WhenToBreakEven, strat1_inputS3_WhenToBreakEven, strat1_inputS4_WhenToBreakEven};
int strat1_InputBreakBy[strat1_NumOfSymbols] = {strat1_inputS1_BreakBy, strat1_inputS2_BreakBy, strat1_inputS3_BreakBy, strat1_inputS4_BreakBy};
int strat1_InputWhenToTrail[strat1_NumOfSymbols] = {strat1_inputS1_WhenToTrail, strat1_inputS2_WhenToTrail, strat1_inputS3_WhenToTrail, strat1_inputS4_WhenToTrail};
int strat1_InputTrailBy[strat1_NumOfSymbols] = {strat1_inputS1_TrailBy, strat1_inputS2_TrailBy, strat1_inputS3_TrailBy, strat1_inputS4_TrailBy};

// Indicator Handles
int strat1_KCHandle1[strat1_NumOfSymbols], strat1_KCHandle2[strat1_NumOfSymbols];

// Indicator Buffers
double strat1_KCUpper1[], strat1_KCLower1[], strat1_KCMid1[];
double strat1_KCUpper2[], strat1_KCLower2[], strat1_KCMid2[];
double strat1_ClosePrice[];

//=========================STRAT 2 VARIABLES (DAILY COUNTER TRENDS)=========================   

//-----INPUT VARIABLES-----

// Multi-Strategy aspects
input ENUM_TIMEFRAMES strat2_inputTradeTF = PERIOD_H1;             // Strategy 2: Traded chart period
input ENUM_TIMEFRAMES strat2_inputIndicatorTF = PERIOD_D1;   

// Risk management inputs
input bool strat2_inputUseBreakEven = true;                        // Strategy 2: Move stop loss to break even? 
input bool strat2_inputUseTrailingStops = true;                    // Strategy 2: Use trailing stop? 

// Balance Management inputs
input bool strat2_UseMoneyManagement = true;
input ENUM_FUNDS_TYPE strat2_inputFundsToUse = UseEquity;          // Strategy 2: Funds to use for lot calculation
input ENUM_MM strat2_inputMMType = Use_ATR_MM;                     // Strategy 2: Type of money management
input double strat2_inputATRMultiplier = 1;                        // Strategy 2: ATR multiplier
input double strat2_inputFixedBalance = 1000;                      // Strategy 2: Amount of balance to be used if Fixed Balance is chosen for FundsToUse
input double strat2_inputFixedRiskMoney = 20;                      // Strategy 2: Fixed risk money
input double strat2_inputRiskPct = 2;                              // Strategy 2: Percentage of funds to risk

// Standard EA features
input int strat2_MagicNum = 1234;                                  // Strategy 2: Magic number
input double strat2_inputLotSize = 0.05;                           // Strategy 2: Lot size
input int strat2_inputSlippage = 50;                               // Strategy 2: Slippage in points
input string strat2_TradeComment = "DailyCounterTrend";            // Strategy 2: strat2_Trade Comment
   
//-----FIRST SYMBOL INPUTS-----
input bool strat2_AllowSymbol1 = false;                                  // Strategy 2 - Enable First Symbol?
input string strat2_inputS1_Symbol = "NZDUSD";                     // Strategy 2: First Symbol
input ENUM_TIMEFRAMES strat2_inputS1_TradeTF = PERIOD_M15;         // Strategy 2 First Symbol: Timeframe we will be trading in 
input ENUM_TIMEFRAMES strat2_inputS1_IndicatorTF = PERIOD_H4;      // Strategy 2 Timeframe we will be getting our indicator from

input int strat2_inputS1_StopLossPips = 10;                        // Strategy 2 First Symbol: Stop loss pips
input int strat2_inputS1_TakeprofitPips = 15;                      // Strategy 2 First Symbol: Take profit pips

input int strat2_inputS1_WhenToBreak = 10;                         // Strategy 2 First Symbol:: When to break even in pips
input int strat2_inputS1_BreakBy = 5;                              // Strategy 2 First Symbol: Break even by how many pips? 

input int strat2_inputS1_WhenToTrail = 7;                          // Strategy 2 First Symbol: When to start trailing
input int strat2_inputS1_TrailBy = 15;                             // Strategy 2 First Symbol: Trailing stop pips

//-----SECOND SYMBOL INPUTS-----
input bool strat2_AllowSymbol2 = false;                                  // Strategy 2 - Enable Second Symbol?
input string strat2_inputS2_Symbol = "CADJPY";                     // Strategy 2 Second Symbol
input ENUM_TIMEFRAMES strat2_inputS2_TradeTF = PERIOD_M30;         // Strategy 2 Second Symbol: Timeframe we will be trading in 
input ENUM_TIMEFRAMES strat2_inputS2_IndicatorTF = PERIOD_H4;      // Strategy 2 Second Symbol: Timeframe we will be getting our indicator from

input int strat2_inputS2_StopLossPips = 20;                        // Strategy 2 Second Symbol: Stop loss pips
input int strat2_inputS2_TakeprofitPips = 30;                      // Strategy 2 Second Symbol: Take profit pips

input int strat2_inputS2_WhenToBreak = 20;                         // Strategy 2 Second Symbol: When to break even in pips
input int strat2_inputS2_BreakBy = 10;                             // Strategy 2 Second Symbol: Break even by how many pips? 

input int strat2_inputS2_WhenToTrail = 15;                         // Strategy 2 Second Symbol: When to start trailing
input int strat2_inputS2_TrailBy = 30;                             // Strategy 2 Second Symbol: Trailing stop pips

//-----THIRD SYMBOL INPUTS-----
input bool strat2_AllowSymbol3 = false;                                  // Strategy 2 - Enable Third Symbol?
input string strat2_inputS3_Symbol = "USDCHF";                     // Strategy 2 Third Symbol 
input ENUM_TIMEFRAMES strat2_inputS3_TradeTF = PERIOD_M15;         // Strategy 2 Third Symbol: Timeframe we will be trading in 
input ENUM_TIMEFRAMES strat2_inputS3_IndicatorTF = PERIOD_H4;      // Strategy 2 Third Symbol: Timeframe we will be getting our indicator from

input int strat2_inputS3_StopLossPips = 10;                        // Strategy 2 Third Symbol: Stop loss pips
input int strat2_inputS3_TakeprofitPips = 15;                      // Strategy 2 Third Symbol: Take profit pips

input int strat2_inputS3_WhenToBreak = 10;                         // Strategy 2 Third Symbol: When to break even in pips
input int strat2_inputS3_BreakBy = 5;                              // Strategy 2 Third Symbol: Break even by how many pips? 

input int strat2_inputS3_WhenToTrail = 7;                          // Strategy 2 Third Symbol: When to start trailing
input int strat2_inputS3_TrailBy = 15;                             // Strategy 2 Third Symbol: Trailing stop pips


//-----GLOBAL VARIABLES-----

// EA Variables
double strat2_StopLossPips[strat2_NumOfSymbols], strat2_TakeProfitPips[strat2_NumOfSymbols]; 

ulong strat2_LastBars[strat2_NumOfSymbols];

double strat2_CurrentBid[strat2_NumOfSymbols], strat2_CurrentAsk[strat2_NumOfSymbols];

int strat2_UsedBars = 30;

double strat2_LevelsHigh[], strat2_LevelsLow[], strat2_ClosePrice[];

string strat2_Symbols[strat2_NumOfSymbols] = {strat2_inputS1_Symbol, strat2_inputS2_Symbol, strat2_inputS3_Symbol};
bool strat2_InputAllowSymbols[strat2_NumOfSymbols] = {strat2_AllowSymbol1, strat2_AllowSymbol2,strat2_AllowSymbol3};

ENUM_TIMEFRAMES strat2_InputTradeTF[strat2_NumOfSymbols] = {strat2_inputS1_TradeTF, strat2_inputS2_TradeTF, strat2_inputS3_TradeTF};
ENUM_TIMEFRAMES strat2_InputIndicatorTF[strat2_NumOfSymbols] = {strat2_inputS1_IndicatorTF, strat2_inputS2_IndicatorTF, strat2_inputS3_IndicatorTF};

int strat2_InputStopLossPips[strat2_NumOfSymbols] = {strat2_inputS1_StopLossPips, strat2_inputS2_StopLossPips, strat2_inputS3_StopLossPips};
int strat2_InputTakeProfitPips[strat2_NumOfSymbols] = {strat2_inputS1_TakeprofitPips, strat2_inputS2_TakeprofitPips, strat2_inputS3_TakeprofitPips};
int strat2_InputWhenToBreak[strat2_NumOfSymbols] = {strat2_inputS1_WhenToBreak, strat2_inputS2_WhenToBreak, strat2_inputS3_WhenToBreak};
int strat2_InputBreakBy[strat2_NumOfSymbols] = {strat2_inputS1_BreakBy, strat2_inputS2_BreakBy, strat2_inputS3_BreakBy};
int strat2_InputWhenToTrail[strat2_NumOfSymbols] = {strat2_inputS1_WhenToTrail, strat2_inputS2_WhenToTrail, strat2_inputS3_WhenToTrail};
int strat2_InputTrailBy[strat2_NumOfSymbols] = {strat2_inputS1_TrailBy, strat2_inputS2_TrailBy, strat2_inputS3_TrailBy};

//=========================INITIALIZATION FUNCTION=========================

int OnInit()
  {
   //===============STRAT 1 INTIALIZATION===============
   
   // Create strat1_Trade object
   strat1_Trade = new CTrade;
   strat1_Trade.SetDeviationInPoints(strat1_inputSlippage);
   strat1_Trade.SetExpertMagicNumber(strat1_MagicNum);

   // Setting event generation timer 
   EventSetTimer(1);
   
   for(int i = 0; i < strat1_NumOfSymbols; i++)
      {
      for(int k = 0; k < strat2_NumOfSymbols; k++)
         {
         if(strat1_Symbols[k] == strat2_Symbols[k])
            {
            Alert(strat1_Symbols[i], " is being used in both strategies");
            ExpertRemove();
            }
         }
      }

   for(int i = 0; i < strat1_NumOfSymbols; i++) 
      {
      if(strat1_InputAllowSymbols[i])
         {
         if(!SymbolMarketWatch(strat1_Symbols[i]))
            {
            Alert(strat1_Symbols[i], " is an invalid symbol");
            ExpertRemove();
            }
         // Initialising LastBars array
         strat1_LastBars[i] = 0;
         
         // Convert stop loss and take profit to pips
         double strat1_point = SymbolInfoDouble(strat1_Symbols[i], SYMBOL_POINT); 
         strat1_StopLossPips[i] = strat1_InputStopLossPips[i] * strat1_point * 10;
         strat1_TakeProfitPips[i] = strat1_InputTakeProfitPips[i] * strat1_point * 10;
            
         strat1_KCHandle1[i] = iCustom(strat1_Symbols[i], strat1_InputTradingTF[i], "Keltner_Channel", strat1_InputMAPeriod1[i]);
         strat1_KCHandle2[i] = iCustom(strat1_Symbols[i], strat1_InputTradingTF[i], "Keltner_Channel", strat1_InputMAPeriod2[i]);  
          
         ArrayResize(strat1_ClosePrice, 3);
         } 
      }
      
   //===============STRAT 2 INTIALIZATION===============
   // Initialize the strat2_Trade object
   strat2_Trade = new CTrade;  // Initialize the pointer
   strat2_Trade.SetExpertMagicNumber(strat2_MagicNum);
   strat2_Trade.SetDeviationInPoints(strat2_inputSlippage);
   
   for(int i = 0; i < strat2_NumOfSymbols; i++) 
      {
      if(strat2_InputAllowSymbols[i])
         {
         if(!SymbolMarketWatch(strat2_Symbols[i]))
            {
            Alert(strat2_Symbols[i], " is an invalid symbol");
            ExpertRemove();
            }         
          // Initialising LastBars array
          strat2_LastBars[i] = 0;
          
          // Convert stop loss and take profit to pips
          double strat2_point = SymbolInfoDouble(strat2_Symbols[i], SYMBOL_POINT); 
          strat2_StopLossPips[i] = strat2_InputStopLossPips[i] * strat2_point * 10;
          strat2_TakeProfitPips[i] = strat2_InputTakeProfitPips[i] * strat2_point * 10;
   
          // Check if we have enough bars on our chart
          if (Bars(strat2_Symbols[i], strat2_InputTradeTF[i]) < 500) 
            {
             Alert("Not enough bars on the chart for: ", strat2_Symbols[i]);
             return (INIT_FAILED);
            }          
         } 
      }
   return(INIT_SUCCEEDED);
  }

//=========================DEINITIALIZATION FUNCTION=========================

void OnDeinit(const int reason)
  {
   //===============START 1 DEINITIALIZATION===============
   EventKillTimer();
   delete strat1_Trade;

   //===============START 2 DEINITIALIZATION===============
   delete strat2_Trade;
  }

void OnTimer()
  {
  //=========================STRAT 1 ON TIMER FUNCTION=========================
   for(int i = 0; i < strat1_NumOfSymbols; i++) 
      {
      if(strat1_InputAllowSymbols[i])
         {
         if (!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !TerminalInfoInteger(TERMINAL_CONNECTED)) {
            Alert("Terminal not connected or Trading not allowed");
            return;
         }
   
         // Check if we have a new bar
         ulong strat1_bars[strat1_NumOfSymbols];
         strat1_bars[i] = Bars(strat1_Symbols[i], strat1_InputTradingTF[i]);
         if (strat1_LastBars[i] != strat1_bars[i]) 
            {
            strat1_LastBars[i] = strat1_bars[i];
            } else 
               {
               continue;
               }
   
         // Get latest bid and ask prices
         strat1_CurrentBid[i] = SymbolInfoDouble(strat1_Symbols[i], SYMBOL_BID);
         strat1_CurrentAsk[i] = SymbolInfoDouble(strat1_Symbols[i], SYMBOL_ASK);
   
         // Declare MqlRates Objects
         MqlRates strat1_PriceDataTable[];
   
         // Reversing ordering of information in our arrays and resizing arrays where appropriate
         ArraySetAsSeries(strat1_KCUpper1, true);
         ArraySetAsSeries(strat1_KCLower1, true);
         ArraySetAsSeries(strat1_KCMid1, true);
         ArraySetAsSeries(strat1_KCUpper2, true);
         ArraySetAsSeries(strat1_KCLower2, true);
         ArraySetAsSeries(strat1_KCMid2, true);
         ArraySetAsSeries(strat1_PriceDataTable, true);
         ArraySetAsSeries(strat1_ClosePrice, true);
   
         // Checking and copying price data
         if(CopyRates(strat1_Symbols[i], strat1_InputTradingTF[i], 0, 3, strat1_PriceDataTable) != 3) 
            {
            Print("Error Copying Price Data", GetLastError());
            continue;
            }
         
         for(int k = 0; k < 3; k++) 
            {
            strat1_ClosePrice[k] = strat1_PriceDataTable[k].close;
            }
   
         // Checking and getting indicator values of the last 3 candlesticks
         if(CopyBuffer(strat1_KCHandle1[i], 2, 0, 3, strat1_KCLower1) != 3 || CopyBuffer(strat1_KCHandle1[i], 0, 0, 3, strat1_KCUpper1) != 3 || CopyBuffer(strat1_KCHandle1[i], 1, 0, 3, strat1_KCMid1) != 3) 
            {
            Print("Error Copying Keltner Channel 1 values", GetLastError());
            continue;
            }
   
         if(CopyBuffer(strat1_KCHandle2[i], 2, 0, 3, strat1_KCLower2) != 3 || CopyBuffer(strat1_KCHandle2[i], 0, 0, 3, strat1_KCUpper2) != 3 || CopyBuffer(strat1_KCHandle2[i], 1, 0, 3, strat1_KCMid2) != 3) 
            {
            Print("Error Copying Keltner Channel 2 values", GetLastError());
            continue;
            }
   
         //-----ENTRY CONDITIONS-----
   
         // Initialize arrays for trade conditions and trends
         bool strat1_LongCondition[strat1_NumOfSymbols];
         bool strat1_ShortCondition[strat1_NumOfSymbols];
         bool strat1_BullTrend[strat1_NumOfSymbols];
         bool strat1_BearTrend[strat1_NumOfSymbols];
         bool strat1_TradeOpen[strat1_NumOfSymbols];
         
         strat1_LongCondition[i] = false;
         strat1_ShortCondition[i] = false;
         strat1_BullTrend[i] = false;
         strat1_BearTrend[i] = false;
         strat1_TradeOpen[i] = false;
               
         // Check if we have open position
         if (NumofDeals(strat1_Symbols[i], strat1_MagicNum) != 0) 
            {
            strat1_TradeOpen[i] = true;
            if (strat1_inputUseBreakEven) 
               {
               BreakEven(strat1_MagicNum, strat1_Symbols[i], strat1_InputWhenToBreakEven[i], strat1_InputBreakBy[i]);
               }
            if (strat1_inputUseTrailingStops) 
               {
               TrailingStopLoss(strat1_MagicNum, strat1_Symbols[i], strat1_InputWhenToTrail[i], strat1_InputTrailBy[i]);
               }
            }
            
         // Determine Trends
         if( (strat1_KCUpper1[1] > strat1_KCUpper2[1]) && (strat1_KCLower1[1] < strat1_KCUpper2[1]) ) 
            {
            strat1_BullTrend[i] = true;
            }
            
         if( (strat1_KCLower1[1] < strat1_KCLower2[1]) && (strat1_KCUpper1[1] > strat1_KCLower2[1]) ) 
            {
            strat1_BearTrend[i] = true;
            }
            
         // Sell Entry Conditions
         if( (strat1_ClosePrice[1] < strat1_KCLower1[1]) && (strat1_ClosePrice[2] > strat1_KCLower1[1]) && (strat1_ClosePrice[2] > strat1_KCLower1[2]) ) 
            {
            strat1_ShortCondition[i] = true;
            }
         
         // Buy Entry Conditions 
         if( (strat1_ClosePrice[1] > strat1_KCUpper1[1]) && (strat1_ClosePrice[2] < strat1_KCUpper1[1]) && (strat1_ClosePrice[2] < strat1_KCUpper1[2]) ) 
            {
            strat1_LongCondition[i] = true;
            }
   
         // Obtain value of our lot size
         double strat1_UsedLots[strat1_NumOfSymbols];
         
         if (strat1_UseMoneyManagement) 
            {
            strat1_UsedLots[i] = MoneyManagement(strat1_Symbols[i], strat1_inputFundsToUse, strat1_inputMMType, strat1_StopLossPips[i], strat1_inputATRMultiplier, strat1_inputFixedBalance, strat1_inputFixedRiskMoney, strat1_inputRiskPct);
            } else 
               {
            strat1_UsedLots[i] = strat1_inputLotSize;
               }
           
         // Buy trade Execution
         if (!strat1_TradeOpen[i]) 
            {
            if (strat1_BullTrend[i] && strat1_LongCondition[i]) 
               {
               strat1_LongTrade(strat1_Symbols[i], strat1_UsedLots[i], strat1_CurrentAsk[i], strat1_CurrentBid[i], strat1_StopLossPips[i], strat1_TakeProfitPips[i]);
               }
            }
        
         // Sell trade Execution
         if (!strat1_TradeOpen[i]) 
            {
            if (strat1_BearTrend[i] && strat1_ShortCondition[i]) 
               {
               strat1_ShortTrade(strat1_Symbols[i], strat1_UsedLots[i], strat1_CurrentAsk[i], strat1_CurrentBid[i], strat1_StopLossPips[i], strat1_TakeProfitPips[i]);
               }
            }
         }         
      }
      // Check if we are allowed to trade

   //=========================STRAT 2 ON TIMER FUNCTION=========================

   for(int i = 0; i < strat2_NumOfSymbols; i++) 
      {
      if(strat2_InputAllowSymbols[i])
         {
         // Check if we are allowed to trade
         if (!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !TerminalInfoInteger(TERMINAL_CONNECTED)) 
            {
            Alert("Terminal not connected or Trading not allowed");
            return;
            }
   
         // Check if we have a new bar
         ulong strat2_bars = Bars(strat2_Symbols[i], strat2_InputTradeTF[i]);
         if (strat2_LastBars[i] != strat2_bars) 
            {
            strat2_LastBars[i] = strat2_bars;
            } else 
               {
               continue;
               }
   
         //----- DATA COLLECTION -----
      
         // Get latest bid and ask prices
         strat2_CurrentBid[i] = SymbolInfoDouble(strat2_Symbols[i], SYMBOL_BID);
         strat2_CurrentAsk[i] = SymbolInfoDouble(strat2_Symbols[i], SYMBOL_ASK);
        
         // Declare MqlRates Objects
         MqlRates strat2_IndicatorTFTable[];
         MqlRates strat2_CurrentRatesTable[];
         
         ArraySetAsSeries(strat2_IndicatorTFTable, true);
         ArraySetAsSeries(strat2_CurrentRatesTable, true);   
         ArraySetAsSeries(strat2_LevelsHigh, true);
         ArraySetAsSeries(strat2_LevelsLow, true);
         ArraySetAsSeries(strat2_ClosePrice, true);
         
         // Resizing our dynamic arrays
         ArrayResize(strat2_LevelsHigh, strat2_UsedBars);
         ArrayResize(strat2_LevelsLow, strat2_UsedBars);
         ArrayResize(strat2_ClosePrice, 3);
         
         // Copy price data
         if (CopyRates(strat2_Symbols[i], strat2_InputIndicatorTF[i], 0, strat2_UsedBars, strat2_IndicatorTFTable) != strat2_UsedBars || CopyRates(strat2_Symbols[i], strat2_InputTradeTF[i], 0, 3, strat2_CurrentRatesTable) != 3) 
            {
            Alert("Error copying price data", GetLastError());
            return;  
            }
      
         // Copy price data from objects to arrays
         for (int j = 0; j < strat2_UsedBars; j++) 
            {
            strat2_LevelsHigh[j] = strat2_IndicatorTFTable[j].high;
            strat2_LevelsLow[j] = strat2_IndicatorTFTable[j].low;
            }
      
         for (int k = 0; k < 3; k++) 
            {
            strat2_ClosePrice[k] = strat2_CurrentRatesTable[k].close;
            }
      
         //-----ENTRY CONDITIONS-----
         
         // Declaring arrays
         bool strat2_LongCondition[strat2_NumOfSymbols];
         bool strat2_ShortCondition[strat2_NumOfSymbols];
         bool strat2_BullTrend[strat2_NumOfSymbols];
         bool strat2_BearTrend[strat2_NumOfSymbols];
         bool strat2_TradeOpen[strat2_NumOfSymbols];
         
         // Initialising arrays
         strat2_LongCondition[i] = false;
         strat2_ShortCondition[i] = false;
         strat2_BullTrend[i] = false;
         strat2_BearTrend[i] = false;
         strat2_TradeOpen[i] = false;
         
         // Check if we have open position
         if (NumofDeals(strat2_Symbols[i], strat2_MagicNum) > 0) 
            {
            strat2_TradeOpen[i] = true;
            if (strat2_inputUseBreakEven) 
               {
               BreakEven(strat2_MagicNum, strat2_Symbols[i], strat2_InputWhenToBreak[i], strat2_InputBreakBy[i]);
               }
            if (strat2_inputUseTrailingStops) 
               {
               TrailingStopLoss(strat2_MagicNum, strat2_Symbols[i], strat2_InputWhenToTrail[i], strat2_InputTrailBy[i]);
               }
            }
   
         // Check for a bull trend
         if ((strat2_LevelsLow[1] > strat2_LevelsLow[2]) && (strat2_LevelsLow[2] > strat2_LevelsLow[3])) 
            {
            strat2_BullTrend[i] = true;
            }
         
         // Check for bear trend
         if ((strat2_LevelsHigh[1] < strat2_LevelsHigh[2]) && (strat2_LevelsHigh[2] < strat2_LevelsHigh[3])) 
            {
            strat2_BearTrend[i] = true;
            }
         
         // Buy order conditions
         if ((strat2_ClosePrice[1] < strat2_LevelsLow[1]) && (strat2_ClosePrice[2] > strat2_LevelsLow[1])) 
            {
            strat2_LongCondition[i] = true;
            }
         
         // Sell order conditions
         if ((strat2_ClosePrice[1] > strat2_LevelsHigh[1]) && (strat2_ClosePrice[2] < strat2_LevelsHigh[1])) 
            {
            strat2_ShortCondition[i] = true;
            }
      
         // Obtain value of our lot size
         double strat2_UsedLots[strat2_NumOfSymbols];
      
         if (strat2_UseMoneyManagement) 
            {
            strat2_UsedLots[i] = MoneyManagement(strat2_Symbols[i], strat2_inputFundsToUse, strat2_inputMMType, strat2_StopLossPips[i], strat2_inputATRMultiplier, strat2_inputFixedBalance, strat2_inputFixedRiskMoney, strat2_inputRiskPct);
            } else 
               {
               strat2_UsedLots[i] = strat2_inputLotSize;
               }
        
         // Buy trade Execution
         if (!strat2_TradeOpen[i]) 
            {
            if (strat2_BullTrend[i] && strat2_LongCondition[i]) 
               {
               strat2_LongTrade(strat2_Symbols[i], strat2_UsedLots[i], strat2_CurrentAsk[i], strat2_CurrentBid[i], strat2_StopLossPips[i], strat2_TakeProfitPips[i]);
               }
            }
         
         // Sell trade Execution
         if (!strat2_TradeOpen[i]) 
            {
            if (strat2_BearTrend[i] && strat2_ShortCondition[i]) 
               {
               strat2_ShortTrade(strat2_Symbols[i], strat2_UsedLots[i], strat2_CurrentAsk[i], strat2_CurrentBid[i], strat2_StopLossPips[i], strat2_TakeProfitPips[i]);
               }
            }
         }        
      }
  }
  
//=========================STRATEGY 1 CUSTOM FUNCTION=========================

//Long trade Function
void strat1_LongTrade(string funSymbol, double lot, double Ask, double Bid, double funStopLoss, double funTakeProfit) 
   {
   strat1_Trade.Buy(lot, funSymbol, Ask, Ask - funStopLoss, Ask + funTakeProfit, strat1_TradeComment);
   }

// Short trade Function
void strat1_ShortTrade(string funSymbol, double lot, double Ask, double Bid, double funStopLoss, double funTakeProfit) 
   {
   strat1_Trade.Sell(lot, funSymbol, Bid, Bid + funStopLoss, Bid - funTakeProfit, strat1_TradeComment);
   }
   
// SymbolMarketWatch Function
bool SymbolMarketWatch(string funSymbol)
  {
   for(int i=0; i<SymbolsTotal(false); i++)
     {
      if(funSymbol==SymbolName(i,false))
        {
         return(true);
        }
     }
     return(false);
  }


//=========================STRATEGY 2 CUSTOM FUNCTIONS=========================  

// Long trade Function
void strat2_LongTrade(string funSymbol, double lot, double Ask, double Bid, double funStopLoss, double funTakeProfit) {
   strat2_Trade.Buy(lot, funSymbol, Ask, Ask - funStopLoss, Ask + funTakeProfit, strat2_TradeComment);
}

// Short trade Function
void strat2_ShortTrade(string funSymbol, double lot, double Ask, double Bid, double funStopLoss, double funTakeProfit) {
   strat2_Trade.Sell(lot, funSymbol, Bid, Bid + funStopLoss, Bid - funTakeProfit, strat2_TradeComment);
}

// Number of deals function
uint NumofDeals(string funSymbol, int funMagicNum) {
   uint Total = 0;
   for(int i = 0; i < PositionsTotal(); i++) {
      if(PositionSelectByTicket(PositionGetTicket(i))) {
         if(PositionGetInteger(POSITION_MAGIC) == funMagicNum && PositionGetString(POSITION_SYMBOL) == funSymbol) {
            Total++;
         }
      }
   }
   return Total;
}
