extends Node
class_name PlayerHand
#Contains all cards that the player have in his inventory

var cards: Array[String] = []#Contains all id cards
var player: AbstractPlayer
var cardsPlayed: Array[String] = []
var maxSize: int = 10	#Nombre de cartes dans la main possible, inutilisé pour le moment

func _init(playerAssociated: AbstractPlayer):
	self.player = playerAssociated

#Add a card to hand
func addCard(idCard: String) -> void:
	cards.append(idCard)

#Remove the card from the hand if the card can be played
func useCard(idCard: String) -> void:
	cards.erase(idCard)
	cardsPlayed.append(idCard)

func getHand() -> Array[String]:
	return cards
