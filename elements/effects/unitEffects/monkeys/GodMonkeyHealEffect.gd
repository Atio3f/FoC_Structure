extends AbstractEffect
class_name GodMonkeyHealEffect


const idEffect = "test:GodMonkeyHealEffect"
const img = ""

func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, -1, 0, true, 6, 0, 0, 0)


func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if(unitAssociated.tile == "test:forest"):
		var healValue = value_A
		healValue = unitAssociated.onHealed(unitAssociated, healValue)
		healValue = unitAssociated.onHeal(unitAssociated, healValue)
		unitAssociated.healHp(healValue)
		unitAssociated.healHp(healValue)
		unitAssociated.healHp(healValue)
