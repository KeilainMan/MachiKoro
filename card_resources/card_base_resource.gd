extends Resource
class_name CardBaseResource

@export_group("Internal Cardproperties")
@export var card_name: String
@export_enum("IncomeCard", "MonumentCard", "SpecialCard") var card_type: String
@export_enum("Player", "All", "Enemys") var card_income_catergory: String:
	get:
		return card_income_catergory
@export var card_income_numbers: Array[int]
@export var card_cost: int
enum all_card_tags {GRAIN, PRODUCTION, LIVESTOCK, CLOTHING, COFFECUP, ENTERTAINMENT}
@export var card_tags: Array[all_card_tags]
@export var income_amount: int

@export_group("Visual Cardproperties")
@export var card_image: Texture
@export var card_ownership: PlayerBase = null

@export_group("Special Card Logic Tags")
enum logic_card_tags { #NEVER CHANGE ORDER
	PLAYERSELECTION = 1,
	ALLENEMYS = 2,
	
	CHOOSECARDSENEMY = 50,
	CHOOSECARDSPLAYER = 51,
	
	SWAPCARDS = 100,
	
	STEALINCOME = 150,
	EARNINCOME = 151,
	}
@export var logic_tags: Array[logic_card_tags]
@export var logic_amount1: int = 0
