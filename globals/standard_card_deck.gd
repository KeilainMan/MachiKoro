extends Node


var all_standard_cards: Array[Dictionary] = [
	{"cardname": "wheat field",			"card_count": 6,	"card_id": 11, 	"card_path": preload("res://card_scenes/wheat_field.tscn")},
	{"cardname": "farm",				"card_count": 6,	"card_id": 5, 	"card_path": preload("res://card_scenes/farm.tscn")},
	{"cardname": "bakery",				"card_count": 6,	"card_id": 1, 	"card_path": preload("res://card_scenes/bakery.tscn")},
	{"cardname": "cafe",				"card_count": 6,	"card_id": 2, 	"card_path": preload("res://card_scenes/cafe.tscn")},
	{"cardname": "mini market",			"card_count": 6,	"card_id": 9, 	"card_path": preload("res://card_scenes/mini_market.tscn")},
	{"cardname": "woods",				"card_count": 6,	"card_id": 12, 	"card_path": preload("res://card_scenes/woods.tscn")},
	{"cardname": "dairy",				"card_count": 6,	"card_id": 3, 	"card_path": preload("res://card_scenes/dairy.tscn")},
	{"cardname": "furniture factory",	"card_count": 6,	"card_id": 6, 	"card_path": preload("res://card_scenes/furniture_factory.tscn")},
	{"cardname": "mine",				"card_count": 6,	"card_id": 8, 	"card_path": preload("res://card_scenes/mine.tscn")},
	{"cardname": "family restaurant",	"card_count": 6,	"card_id": 4, 	"card_path": preload("res://card_scenes/family_restaurant.tscn")},
	{"cardname": "orchard",				"card_count": 6,	"card_id": 10, 	"card_path": preload("res://card_scenes/orchard.tscn")},
	{"cardname": "market",				"card_count": 6,	"card_id": 7, 	"card_path": preload("res://card_scenes/market.tscn")},
	{"cardname": "train_station",		"card_count": 4,	"card_id": 13,	"card_path": preload("res://card_scenes/train_station.tscn")},
	{"cardname": "mall",				"card_count": 4,	"card_id": 14,	"card_path": preload("res://card_scenes/mall.tscn")},
	{"cardname": "amusement_park",		"card_count": 4,	"card_id": 15,	"card_path": preload("res://card_scenes/amusement_park.tscn")},
	{"cardname": "radio_station",		"card_count": 4,	"card_id": 16,	"card_path": preload("res://card_scenes/radio_station.tscn")},
	]:
	get:
		return all_standard_cards.duplicate()

var all_playercount_based_cards: Array = [
	{"cardname": "bakery",				"card_count": 2,	"card_id": 1},
	{"cardname": "cafe",				"card_count": 6,	"card_id": 2},
	{"cardname": "dairy",				"card_count": 6,	"card_id": 3},
	{"cardname": "family restaurant",	"card_count": 6,	"card_id": 4},
	{"cardname": "farm",				"card_count": 6,	"card_id": 5},
	{"cardname": "furniture factory",	"card_count": 6,	"card_id": 6},
	{"cardname": "market",				"card_count": 6,	"card_id": 7},
	{"cardname": "mine",				"card_count": 6,	"card_id": 8},
	{"cardname": "mini market",			"card_count": 6,	"card_id": 9},
	{"cardname": "orchard",				"card_count": 6,	"card_id": 10},
	{"cardname": "wheat field",			"card_count": 6,	"card_id": 11},
	{"cardname": "woods",				"card_count": 6,	"card_id": 12},
	{"cardname": "train_station",		"card_count": 4,	"card_id": 13},
	{"cardname": "mall",				"card_count": 4,	"card_id": 14},
	{"cardname": "amusement_park",		"card_count": 4,	"card_id": 15},
	{"cardname": "radio_station",		"card_count": 4,	"card_id": 16},
]:
	get:
		return all_playercount_based_cards
