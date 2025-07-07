extends AbstractEffect
class_name GodMonkeySpeedEffect


const idEffect = "test:GodMonkeySpeedEffect"
const img = ""

func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, -1, 0, false, 1, 0, 0, 0)
	

func onPlacement(tile: String) -> void:
	unitsStocked = unitAssociated.player.getUnitsByTag(Tags.tags.MONKEY)
	var effectAdd : AbstractEffect
	for unit: AbstractUnit in unitsStocked :
		#We remove the god Monkey from this effect
		if unit == unitAssociated : 
			unitsStocked.erase(unit)
			continue
		effectAdd = GodMonkeyMinionEffect.new(unit, self)
		unit.addEffect(effectAdd)
	updateValue(unitsStocked.size())

func onUnitPlace(unit: AbstractUnit) -> void:
	if(unit.tags.has(Tags.tags.MONKEY) && unit.player.team == unitAssociated.team):
		unitsStocked.append(unit)
		var effectAdd : AbstractEffect = GodMonkeyMinionEffect.new(unit, self)
		unit.addEffect(effectAdd)
		updateValue(counter + 1)

func onDeath(unit: AbstractUnit) -> void :
	for _unit: AbstractUnit in unitsStocked :
		#Find effect on each unit and remove it
		1

#newValue == number of Monkey alived
func updateValue(newValue: int) -> void:
	if (counter - newValue) == 0 : return
	var speedCgtEffect = SpeedPlusEffect.new(unitAssociated, (newValue - counter) * value_A)
	unitAssociated.addEffect(speedCgtEffect)
	counter = newValue


