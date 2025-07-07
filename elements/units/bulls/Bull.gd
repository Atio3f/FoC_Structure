extends AbstractUnit
class_name Bull

const idUnit = "test:Bull"
const POTENTIAL = 2
const img = ""
func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, 43, 19, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 8, 5, 0, POTENTIAL, 1)
	tags.append(Tags.tags.BULL)
	self.movementTypes = [MovementTypes.movementTypes.WALK]
	self.actualMovementTypes = MovementTypes.movementTypes.WALK
