/obj/machinery/syndicatebomb/
	/// List of which experts have already examined the bomb
	var/list/examined_bomb = list()

/// Called when an explosive expert examines the bomb
/obj/machinery/syndicatebomb/proc/expert_examine(mob/user)
	// One expert can at most reveal half of the detonation wires
	for(var/i in examined_bomb)
		if(i == user)
			return
	var/datum/wires/syndicatebomb/bomb_wires = wires
	var/wires_revealed = 0
	var/list/found_wires = list()
	var/boom_wires = 2
	// Number of boom wires is never stored everywhere so we need to recalculate how many we have
	if(add_boom_wires)
		var/dud_wires
		boom_wires = clamp(round(timer_set / 45, 1), 2, 12)
		if(boom_wires >= 3)
			dud_wires = floor(boom_wires / 2)
			boom_wires -= dud_wires
	for(var/i in bomb_wires.wires)
		to_chat(user, "FUCK")
		if((bomb_wires.parse_wire(i) == WIRE_BOOM) && (wires_revealed <= floor(boom_wires / 2)))
			var/color_to_add = bomb_wires.get_color_of_wire(i)
			found_wires.Add(color_to_add)
			to_chat(user, "[bomb_wires.get_color_of_wire(i)] [i] [color_to_add]")
	to_chat(user, "[found_wires], fuck fuck fuck fuck [boom_wires]")

/obj/machinery/syndicatebomb/activate()
	. = ..()
	examined_bomb = list()

/datum/wires/syndicatebomb/interact(mob/user)
	if(HAS_TRAIT(user, TRAIT_POWER_EXPLOSIVES_SPECIALIST) && interactable(user))
		var/obj/machinery/syndicatebomb/bomb = holder
		bomb.expert_examine(user)
		bomb.examined_bomb.Add(user)
	return ..()




