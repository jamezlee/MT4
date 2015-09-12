#property  copyright "james Lee"


extern double LotSize = 0.1;
extern double StopLoss = 50;

extern double TakeProfit = 100;

extern int Slippage = 5;
extern int MagicNumber =123;

extern int FastMAPeriod =10;
extern int SlowMAPeriod = 20;


//Global Variables

int BuyTicket;
int SellTicket;

double UsePoint;
int UseSlippage;

//Init function

int init()
{
   usePoint = PipPoint(Symbol ());
   UseSlippage = GetSlippage (Symbol(),Slippage);

}

//Start function
int start()

{
//Moving averages
double FastMA =iMA(NULL,0,FastMAPeriod,0,0,0,0);
double SlowMA =iMA(NULL,0,SlowMAPeriod,0,0,0,0);

   //Buy order
   if(FastMA > SlowMA && BuyTicket == 0)
   {
      OrderSelect(SellTicket,SELECT_BY_TICKET);
      
      //Close order
      if(OrderCloseTime()==0 && SellTicket >0)
      {
         double CloseLots = OrderLots();
         double ClosePrice = Ask;
         
         bool Closed = OrderClose(SellTicket,CloseLots,ClosePrice,UseSlippage,Red);
         
      }
      double OpenPrice = Ask;
      
      //Calculate stop loss and take profit
      if(StopLoss >0) double BuyStopLoss = OpenPrice - StopLoss*UsePoint);
      
   
   }

}