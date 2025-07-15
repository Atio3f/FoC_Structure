class_name AbstractItem

var id: String
var nameItem: String
var imgPath: String
var playerAssociated: AbstractPlayer
var orbCost: int	#Coût en orbe de l'objet
var orbCostBase: int
var equipable: bool	#If the item is to be place on a unit(consumables counts like equipable)

#3 values like effects to keep parameters for items 
var value_A: int
var value_B: int
var value_C: int 
var counter: int #Can be used to increment a value 

func _init(id: String, imgPath: String, playerAssociated: AbstractPlayer, orbsCost: int, equipable: bool, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	self.id = id
	self.nameItem = id.substr(5)
	self.imgPath = imgPath
	#INSERER IMAGE A PARTIR DU PATH ICI
	self.playerAssociated = playerAssociated
	self.orbCost = orbCost
	self.orbCostBase = orbCost
	self.equipable = equipable
	self.value_A = value_A
	self.value_B = value_B
	self.value_C = value_C
	self.counter = counter

func canBeUsed(unit: AbstractUnit) -> bool:
	return orbCost <= playerAssociated.orbs

func useItem(unit: AbstractUnit) -> bool:
	if !canBeUsed(unit) : return false
	playerAssociated.orbs -= orbCost
	unit.onItemUsed(self, playerAssociated)
	return true

func registerItem() -> Dictionary:
	return {}

static func recoverItem(data: Dictionary, hand: PlayerHand) -> void:#AbstractItem:
	return
