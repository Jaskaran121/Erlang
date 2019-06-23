-module(bank).

-export([startprocessBank/3]).

startprocessBank(MasterPid, BankName, BankAmount) ->
    timer:sleep(rand:uniform(10)),
    receive
      {From, CustomerName, CustomerAmount} ->
	  if CustomerAmount < BankAmount ->
        NewBankAmount = BankAmount - CustomerAmount,
        From ! {'approve'};
         true -> NewBankAmount = BankAmount,
         From ! {'decline'}
    end,
	  startprocessBank(MasterPid, BankName, NewBankAmount)
    end.
