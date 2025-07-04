extends AbstractEffect
class_name BerserkerBullEffect

const idEffect = "test:BerserkerBullEffect"
const img = ""

func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, -1, 0, true, 2, 0, 0, 0)


func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	return damage * 2

func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes) -> int :
	return damage * 2
