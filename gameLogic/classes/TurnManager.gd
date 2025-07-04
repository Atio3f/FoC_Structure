extends Node
class_name TurnManager
#Manage all end of turn actions and to decide which team have to play

var turn : int = 0 #Actual turn number
var teams : Array[int] = []	#int is the id of each player
var gameManager : GameManager


func nextTurn():
	var nextTurn = teams[(turn+1) % teams.size()]
	#Appel de toutes les unités pour appliquer les effets en envoyant le tour actuel et le tour à venir
	for unit : AbstractUnit in gameManager.getUnits() :
		
	#Animation du bouton et actualisation de l'interface
