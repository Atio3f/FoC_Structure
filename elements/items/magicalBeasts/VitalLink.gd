extends AbstractItem
class_name VitalLink

const idUnit = "test:VitalLink"
const img = ""
const HEAL_VALUE = 10
const BONUS_HEAL = 5

func _init(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	1

func canBeUsed(unitAssociated: AbstractUnit) -> bool :
	if unit.tile == "tile:forest" : return true
	else :return false
