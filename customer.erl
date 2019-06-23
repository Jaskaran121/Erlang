-module(customer).

-export([startprocessCustomer/4]).

startprocessCustomer(MoneyPID, CustomerName,CustomerAmt, BankInfo) ->
    timer:sleep(rand:uniform(10)),
    if
            (CustomerAmt =< 0) or (length(BankInfo)=<0) ->
                timer:sleep(2000),
                MoneyPID ! {CustomerName,CustomerAmt};
            true ->
                    CurrentBank = lists:nth(rand:uniform(length(BankInfo)),BankInfo),
                    {BankName, BankAmount} = CurrentBank,
                    if (CustomerAmt<50) ->
                            % io:fwrite('Remaining Amount ~p for less than 50 customer: ~p~n',[CustomerAmt,CustomerName]),
                        CurrentLoanRequest = rand:uniform(CustomerAmt);
                    true ->
                            % io:fwrite('Remaining Amount ~p for more than 50 customer: ~p~n',[CustomerAmt,CustomerName]),
                        CurrentLoanRequest = rand:uniform(50)
                    end,
                    BankName ! {self(), CustomerName, CurrentLoanRequest},
                    io:fwrite("Loan requested by customer ~p of amount ~p "
                            "from bank ~p~n",
                            [CustomerName, CurrentLoanRequest, BankName]),
                    receive
                    {Message} ->
                    if 
                        Message == 'approve' ->
                        io:fwrite("Loan approved by bank ~p of amount ~p "
                            "for customer ~p~n",
                            [BankName, CurrentLoanRequest, CustomerName]),
                        startprocessCustomer(MoneyPID, CustomerName,
                                    CustomerAmt - CurrentLoanRequest,
                                    BankInfo);
                        Message == 'decline' ->
                            io:fwrite("Loan rejected by bank ~p of amount ~p "
                                "for customer ~p~n",
                                [BankName, CurrentLoanRequest, CustomerName]),
                            CurrentBankInfo = lists:delete(CurrentBank, BankInfo),
                            startprocessCustomer(MoneyPID, CustomerName,
                                        CustomerAmt, CurrentBankInfo);
                    true ->
                        ok
                    end
    end       
    end.

