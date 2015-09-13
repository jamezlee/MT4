#property copyright "Andrew Young"
// External variables
extern double LotSize = 0.1;
extern double StopLoss = 50;
extern double TakeProfit = 100;
extern int Slippage = 5;
extern int MagicNumber = 123;
extern int FastMAPeriod = 10;
extern int SlowMAPeriod = 20;


//moitify,just added
extern int PendingPips = 10;

// Global variables
int BuyTicket;
int SellTicket;



double UsePoint;
int UseSlippage;
// Init function
int init()
{
   UsePoint = PipPoint(Symbol());
   UseSlippage = GetSlippage(Symbol(),Slippage);
}
// Start function
   int start()
   {
      // Moving averages
      double FastMA = iMA(NULL,0,FastMAPeriod,0,0,0,0);
      double SlowMA = iMA(NULL,0,SlowMAPeriod,0,0,0,0);
      // Buy order
      if(FastMA > SlowMA && BuyTicket == 0)
      {
      OrderSelect(SellTicket,SELECT_BY_TICKET);
         // Close order, if any exist ticket and close
         if(OrderCloseTime() == 0 && SellTicket > 0 && OrderType() == OP_SELL )
         {
         double CloseLots = OrderLots();
         double ClosePrice = Ask;
         bool Closed = OrderClose(SellTicket,CloseLots,ClosePrice,UseSlippage,Red);
         if(Closed == true) SellTicket = 0;//just added
         }
         
         // Delete Order //just added
         else if(OrderCloseTime() == 0 && SellTicket > 0 && OrderType() == OP_SELLSTOP)
         {
         bool Deleted = OrderDelete(SellTicket,Red);
         if(Deleted == true) SellTicket = 0;
         }

      double PendingPrice = Close[0] + (PendingPips * UsePoint);
      double OpenPrice = Ask;
      // Calculate stop loss and take profit
      if(StopLoss > 0) double BuyStopLoss = PendingPrice - (StopLoss * UsePoint);
      if(TakeProfit > 0) double BuyTakeProfit = PendingPrice + (TakeProfit * UsePoint);
      // Open buy order
      //BuyTicket = OrderSend(Symbol(),OP_BUY,LotSize,OpenPrice,UseSlippage,
      //BuyStopLoss,BuyTakeProfit,"Buy Order",MagicNumber,0,Green);
      
      BuyTicket = OrderSend(Symbol(),OP_BUYSTOP,LotSize,PendingPrice,UseSlippage, BuyStopLoss,BuyTakeProfit,"Buy Stop Order",MagicNumber,0,Green);


      SellTicket = 0;
      }
         // Sell Order
         if(FastMA < SlowMA && SellTicket == 0)
         {
            OrderSelect(BuyTicket,SELECT_BY_TICKET);
            
            if(OrderCloseTime() == 0 && BuyTicket > 0 && OrderType() == OP_BUY)
               {
               CloseLots = OrderLots();
               ClosePrice = Bid;
               Closed = OrderClose(BuyTicket,CloseLots,ClosePrice,UseSlippage,Red);
               if(Closed == true) BuyTicket = 0;
               }
               // Delete Order
               else if(OrderCloseTime() == 0 && BuyTicket > 0 && OrderType() == OP_BUYSTOP)
               {
               Closed = OrderDelete(BuyTicket,Red);
               if(Closed == true) BuyTicket = 0;
               }
               PendingPrice = Close[0] - (PendingPips * UsePoint);
               double SellStopLoss = PendingPrice + (StopLoss * UsePoint);
               double SellTakeProfit = PendingPrice - (TakeProfit * UsePoint);
               SellTicket = OrderSend(Symbol(),OP_SELLSTOP,LotSize,PendingPrice,UseSlippage,
               SellStopLoss,SellTakeProfit,"Sell Stop Order",MagicNumber,0,Red);
               BuyTicket = 0;
         }
      return(0);
   }
   
   // Pip Point Function
   double PipPoint(string Currency)
   {
      int CalcDigits = MarketInfo(Currency,MODE_DIGITS);
      if(CalcDigits == 2 || CalcDigits == 3) double CalcPoint = 0.01;
      else if(CalcDigits == 4 || CalcDigits == 5) CalcPoint = 0.0001;
      return(CalcPoint);
   }
   
   // Get Slippage Function
   int GetSlippage(string Currency, int SlippagePips)
   {
      int CalcDigits = MarketInfo(Currency,MODE_DIGITS);
      if(CalcDigits == 2 || CalcDigits == 4) double CalcSlippage = SlippagePips;
      else if(CalcDigits == 3 || CalcDigits == 5) CalcSlippage = SlippagePips * 10;
      return(CalcSlippage);
   }
