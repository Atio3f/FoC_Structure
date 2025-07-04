extends AbstractUnit
class_name BerserkerBull

const idUnit = "test:BerserkerBull"
const POTENTIAL = 2
const img = ""
func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, 50, 24, DamageTypes.DamageTypes.PHYSICAL, 1, 9, 5, 0, POTENTIAL, 0)
	var effect1: AbstractEffect = BerserkerBullEffect.new(self)
	effects.append(effect1)
	tags.append(Tags.tags.BULL)
