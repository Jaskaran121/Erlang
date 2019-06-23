-module(customer).

-export([startprocessCustomer/4]).

startprocessCustomer(ControllerPID, CustomerName,CustomerAmt, BankInfo) ->
    timer:sleep(rand:uniform(10)),
    if 
        (CustomerAmt > 0) or (length(BankInfo)>0) ->
            CurrentBank = lists:nth(rand:uniform(length(BankInfo)),BankInfo),
            {BankName, BankAmount} = CurrentBank,
            if (CustomerAmt<50) ->
                    io:fwrite('Remaining Amount for customer: ~p~n',[CustomerAmt]),
                CurrentLoanRequest = rand:uniform(CustomerAmt);
            true ->
                    io:fwrite('Remaining Amount for customer: ~p~n',[CustomerAmt]),
                CurrentLoanRequest = rand:uniform(50)
            end,
            BankName ! {self(), CustomerName, CurrentLoanRequest},
            io:fwrite("Loan requested by customer ~p of amount ~p "
                    "from bank ~p~n",
                    [CustomerName, CurrentLoanRequest, BankName]),
            receive
            {Message} ->
                    % io:fwrite("~p~n",[Message]),
            if Message == 'approve' ->
                io:fwrite("Loan approved by bank ~p of amount ~p "
                    "for customer ~p~n",
                    [BankName, CurrentLoanRequest, CustomerName]),
                startprocessCustomer(ControllerPID, CustomerName,
                            CustomerAmt - CurrentLoanRequest,
                            BankInfo);
                Message == 'decline' ->
                    io:fwrite("Loan rejected by bank ~p of amount ~p "
                        "for customer ~p~n",
                        [BankName, CurrentLoanRequest, CustomerName]),
                    CurrentBankInfo = lists:delete(CurrentBank, BankInfo),
                    startprocessCustomer(ControllerPID, CustomerName,
                                CustomerAmt, CurrentBankInfo);
            true ->
                io:fwrite('Here')
            end;
      true ->
            io:fwrite('Problem in true'),
            ControllerPID ! {CustomerName,CustomerAmt}
    end
    end.
