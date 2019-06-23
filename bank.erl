-module(bank).

-export([startprocessBank/3]).

startprocessBank(MasterPid, BankName, BankAmount) ->
    timer:sleep(rand:uniform(10)),
    receive
      {From, CustomerName, CustomerAmount} ->
	  if CustomerAmount < BankAmount ->
            NewBankAmount = BankAmount - CustomerAmount,
            From ! {'approve'},
            startprocessBank(MasterPid, BankName, NewBankAmount);
         true -> NewBankAmount = BankAmount,
            From ! {'decline'},
            startprocessBank(MasterPid, BankName, NewBankAmount)
    end
    after 2000 ->
      timer:sleep(500),
      MasterPid ! {"bank",BankName,BankAmount}
    end.
