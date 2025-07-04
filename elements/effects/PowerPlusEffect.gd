extends AbstractEffect
class_name PowerPlusEffect

const idEffect = "test:PowerPlusEffect"
const img = ""

func _init(unit: AbstractUnit, value: int):
	super._init(idEffect, img, unit, -1, 0, true, value, 0, 0, 0)
	
	
func onEffectApplied(firstTime: bool, oldEffect:AbstractEffect = null):
	print("Boost pour "+unitAssociated.uid)
	unitAssociated.power += value_A if firstTime else oldEffect.value_A
	print(unitAssociated.power)



