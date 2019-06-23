%% @author JASKARN SINGH
%% @doc @todo Add description to controller.

-module(money).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).

%% ====================================================================
%% Internal functions
%% ====================================================================

start() ->
    {ok, CustomersInfo} = file:consult("customers.txt"),
    {ok, BanksInfo} = file:consult("banks.txt"),
    readFile(BanksInfo, "b", BanksInfo),
    readFile(CustomersInfo, "c", BanksInfo),
    listener(CustomersInfo,BanksInfo).

listener(CustomersInfo,BanksInfo) ->
        receive
                {CustomerName, CustomerAmount} ->
                      {_,{_,BeforeLoanCustomerAmount}} = lists:keysearch(CustomerName, 1, CustomersInfo),
                      if
                            (CustomerAmount == 0) ->
                                io:fwrite("~p has reached the objective of ~p dollar(s). Woo Hoo!~n",[CustomerName,BeforeLoanCustomerAmount]);
                            true ->
                                io:fwrite("~p was only able to borrow ~p dollar(s).Boo Hoo!~n",[CustomerName,CustomerAmount])
                      end,
                      listener(CustomersInfo,BanksInfo);
                {_,BankName,BankAmount} ->
                        io:fwrite("~p has ~p dollar(s) remaining.~n",[BankName,BankAmount]),
                        listener(CustomersInfo,BanksInfo)
        end.
        
readFile(Info, Identifier, BanksInfo) ->
    whileSpawn(Info, Identifier,
	       BanksInfo).                         %% 	get_Id(Pid).

whileSpawn([], Identifier, BanksInfo) -> ok;
whileSpawn([H | T], Identifier, BanksInfo) ->
    if Identifier == "b" ->
       {Bankname, Bankamt} = H,
	   BankPid = spawn(bank, startprocessBank,
			   [self(), Bankname, Bankamt]),
	   register(Bankname, BankPid),
	   whileSpawn(T, Identifier, BanksInfo);
       Identifier == "c" ->
	   {CustomerName, CustomerAmount} = H,
	   spawn(customer, startprocessCustomer,
			       [self(), CustomerName, CustomerAmount,
				BanksInfo]),
	   whileSpawn(T, Identifier, BanksInfo);
       true -> ok
    end.

