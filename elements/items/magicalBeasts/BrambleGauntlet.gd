extends AbstractItem
class_name BrambleGauntlet

const idUnit = "test:BrambleGauntlet"
const img = ""
const DAMAGE_BONUS = 2
const SPEED_MALUS = -4
const SPEED_MALUS_DURATION = 3

func _init(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	var effect: AbstractEffect = BrambleGauntletEffect.new(unitAssociated, -1, DAMAGE_BONUS, SPEED_MALUS, SPEED_MALUS_DURATION)
	unitAssociated.addEffect(effect)
