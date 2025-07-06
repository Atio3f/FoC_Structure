extends AbstractEffect
class_name BerserkerBullEffect

const idEffect = "test:BerserkerBullEffect"
const img = ""
const DMG_MULTIPLIER = 2
const HEAL_VALUE = 10

func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, -1, 100, true, DMG_MULTIPLIER, HEAL_VALUE, 0, 0)


func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	return damage * value_A

func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes) -> int :
	return damage * value_A


func onKill(unitKilled: AbstractUnit) -> void :
	var healValue: int = value_B
	unitAssociated.onHeal(null, healValue)
	unitAssociated.healHp(healValue)
