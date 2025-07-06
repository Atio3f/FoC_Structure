extends AbstractEffect
class_name SpeedPlusEffect

const idEffect = "test:SpeedPlusEffect"
const img = ""

func _init(unit: AbstractUnit, value: int):
	super._init(idEffect, img, unit, -1, 0, true, value, 0, 0, 0)
	
	
func onEffectApplied(firstTime: bool, oldEffect:AbstractEffect = null):
	print("Boost speed pour "+unitAssociated.uid)
	unitAssociated.speed += value_A if firstTime else oldEffect.value_A
	print(unitAssociated.speed)


