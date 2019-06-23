-module(bank).

-export([startprocessBank/3]).

startprocessBank(ControllerPID, BankName, BankAmount) ->
    timer:sleep(rand:uniform(10)),
    receive
      {From, CustomerName, CustomerAmount} ->
	  if CustomerAmount < BankAmount ->
        NewBankAmount = BankAmount - CustomerAmount,
        io:fwrite('Remaining Amount in Bank: ~p~n',[NewBankAmount]),
        From ! {'approve'};
         true -> NewBankAmount = BankAmount,
         From ! {'decline'}
	  end,
	  startprocessBank(ControllerPID, BankName, NewBankAmount)
    end.
