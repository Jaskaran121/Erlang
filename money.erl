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
    % io:fwrite("~w ~n", [CustomersInfo]),
    {ok, BanksInfo} = file:consult("banks.txt"),
    readFile(BanksInfo, "b", BanksInfo),
    readFile(CustomersInfo, "c", BanksInfo),
    receive
      {CustomerName, CustomerAmount} ->
            io:fwrite("~p~p ~n", [CustomerName,CustomerAmount])
	  end.
    % readFile(CustomersInfo, "c", BankLength).

readFile(Info, Identifier, BanksInfo) ->
    whileSpawn(Info, Identifier,
	       BanksInfo).    %%   	Pid = spawn(fun() -> while(Info) end),

                           %% 	get_Id(Pid).

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
	   CustomerPid = spawn(customer, startprocessCustomer,
			       [self(), CustomerName, CustomerAmount,
				BanksInfo]),
	   whileSpawn(T, Identifier, BanksInfo);
       true -> io:fwrite("Error")
    end.

