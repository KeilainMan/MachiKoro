extends Node

## PLAYER INFORMATION
signal new_current_player(player) #from Main(Gamboard) to GameManager
signal players_registered(all_players) #from Main(Gamboard) to GameManager


## DICE ROLL SIGNALS
signal throw_one_dice() #from TurnProcessUI to GameManager
signal throw_two_dice() #from TurnProcessUI to GameManager
