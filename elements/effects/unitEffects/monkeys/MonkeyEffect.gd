extends AbstractEffect
class_name MonkeyEffect


const idEffect = "test:MonkeyEffect"
const img = ""

func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, -1, 0, true, 2, 0, 0, 0)


func onPlacement(tile: String) -> void:
	unitsStocked = unitAssociated.player.getUnitsByTag(Tags.tags.MONKEY)
	var effectAdd : AbstractEffect
	for unit: AbstractUnit in unitsStocked :
		effectAdd = PowerPlusEffect.new(unit, value_A)
		unit.addEffect(effectAdd)

func onUnitPlace(unit: AbstractUnit) -> void:
	if(unit.tags.has(Tags.tags.MONKEY) && unit.player.team == unitAssociated.team):
		unitsStocked.append(unit)
		var effectAdd : AbstractEffect = PowerPlusEffect.new(unit, value_A)
		unit.addEffect(effectAdd)

func onDeath(unit: AbstractUnit) -> void :
	var effectAdd : AbstractEffect
	for _unit: AbstractUnit in unitsStocked :
		effectAdd = PowerPlusEffect.new(_unit, -value_A)
		_unit.addEffect(effectAdd)
