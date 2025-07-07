extends AbstractEffect
class_name IroncladBullEffect

const idEffect = "test:IroncladBullEffect"
const img = ""
const DR_VALUE = 3

func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, -1, 100, false, DR_VALUE, 0, 0, 0)


func onLevelUp(level: int) -> void :
	unitAssociated.dr += value_A
	counter += value_A	#If we need one day to reset the buff
