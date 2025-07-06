extends AbstractEffect
class_name GodMonkeyMinionEffect


const idEffect = "test:GodMonkeyMinionEffect"
const img = ""
var effectAssociated: AbstractEffect
func _init(unit: AbstractUnit, effectAssociated: AbstractEffect):
	super._init(idEffect, img, unit, -1, 0, true, 0, 0, 0, 0)
	self.hideEffect = true
	self.effectAssociated = effectAssociated


func onDeath(unit: AbstractUnit) -> void :
	self.effectAssociated.updateValue(self.effectAssociated.counter - 1)
	self.effectAssociated.unitsStocked.erase(unitAssociated)
	unitAssociated.effects.erase(self)
	queue_free()
