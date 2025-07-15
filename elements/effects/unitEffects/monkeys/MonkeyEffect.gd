extends AbstractEffect
class_name MonkeyEffect


const idEffect = "test:MonkeyEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, 0, 0, 0)


func onPlacement(tile: String) -> void:
	unitsStocked = unitAssociated.player.getUnitsByTag(Tags.tags.MONKEY)
	var effectAdd : AbstractEffect
	for unit: AbstractUnit in unitsStocked :
		effectAdd = PowerPlusEffect.new(unit, -1, value_A)
		unit.addEffect(effectAdd)

func onUnitPlace(unit: AbstractUnit) -> void:
	if(unit.tags.has(Tags.tags.MONKEY) && unit.player.team == unitAssociated.team):
		unitsStocked.append(unit)
		var effectAdd : AbstractEffect = PowerPlusEffect.new(unit, -1, value_A)
		unit.addEffect(effectAdd)

func onDeath(unit: AbstractUnit) -> void :
	var effectAdd : AbstractEffect
	for _unit: AbstractUnit in unitsStocked :
		effectAdd = PowerPlusEffect.new(_unit, -1, -value_A)
		_unit.addEffect(effectAdd)
