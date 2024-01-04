extends Node

## PLAYER INFORMATION
signal new_current_player(player) #from Main(Gamboard) to GameManager
signal players_registered(all_players) #from Main(Gamboard) to GameManager
signal player_money_increased(player, money) #from player to helper
signal player_money_decreased(player, money) #from player to helper
signal player_card_added(player, cardname) #from player to helper
signal player_card_removed(player, cardname) #from player to helper

###GAMELOOP RELATED SIGNALS
## DICE ROLL SIGNALS
signal throw_one_dice() #from TurnProcessUI to GameManager
signal throw_two_dice() #from TurnProcessUI to GameManager
signal dice_throw_succeced() #from GameManager to DiceThrowButtons
signal skip_dicethrow() #form gameboard to dices
signal send_dice_throw_result(results) #from DiceThrow to GameManager


## UI SIGNALS
signal toggle_shop() # from TurnProcessMenu to ShopContainer
signal player_card_container_toggled() #from PlayerCardContainerButton in Main to PlayerCardsContainer

## SHOP SIGNALS
signal card_wants_to_be_bought() #from a CardBase to GameManager
signal card_was_bought(card) #from GameManager to PlayerCardsContainer

##TURNORDER SIGNALS
signal turn_finished() #from TurnEndButton to GameManager
signal new_turn_starts() #from GameManager to UI and everything that needs to be refreshed on the new turn


## OPTICAL SIGNALS
signal disable_buttons() #from anywhere to ButtonBase, to disable buttons
signal enable_buttons() #from anywhere to ButtonBase, to enable buttons
