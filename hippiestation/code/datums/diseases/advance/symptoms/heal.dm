/datum/symptom/oxygen	//It makes no sense for this one to be so punishing for viruses
	resistance = -1
	stage_speed = -1
	transmittable = -2

/datum/symptom/heal/starlight
	level = 0

/datum/symptom/heal/chem
	level = 0

/datum/symptom/heal/metabolism
	level = 0

/datum/symptom/heal/darkness
	level = 0

/datum/symptom/heal/coma
	stealth = 0
	resistance = 2
	stage_speed = -2
	transmittable = -2
	level = 8

/datum/symptom/heal/water
	level = 0

/datum/symptom/heal/plasma
	stealth = 0
	resistance = 3
	stage_speed = -2
	transmittable = -2
	level = 6

/datum/symptom/heal/radiation
	level = 0

/datum/symptom/heal/toxin
	name = "Toxic Filter"
	desc = "The virus synthesizes regenerative chemicals in the bloodstream, repairing damage caused by toxins."
	stealth = 1
	resistance = -2
	stage_speed = -2
	transmittable = -2
	level = 4
	threshold_desc = "<b>Stage Speed 6:</b> Doubles healing speed."

/datum/symptom/heal/toxin/Start(datum/disease/advance/A)
	if(A.properties["stage_rate"] >= 6) //stronger healing
		power = 2

	 //100% chance to activate for slow but consistent healing
/datum/symptom/heal/toxin/Heal(mob/living/M, datum/disease/advance/A)
	var/heal_amt = 1 * power
	M.adjustToxLoss(-heal_amt)
	return TRUE

/datum/symptom/heal/supertoxin
	name = "Apoptoxin filter"
	desc = "The virus stimulates production of special stem cells in the bloodstream, causing rapid reparation of any damage caused by toxins."
	stealth = 0
	resistance = -2
	stage_speed = -2
	transmittable = -2
	level = 6
	threshold_desc = ""

/datum/symptom/heal/supertoxin/Heal(mob/living/M, datum/disease/advance/A)
	var/heal_amt = 4
	M.adjustToxLoss(-heal_amt)
	return TRUE

/datum/symptom/heal/brute
	name = "Regeneration"
	desc = "The virus stimulates the regenerative process in the host, causing faster wound healing."
	stealth = 1
	resistance = -2
	stage_speed = -2
	transmittable = -2
	level = 4
	threshold_desc = "<b>Stage Speed 6:</b> Doubles healing speed."

/datum/symptom/heal/brute/Start(datum/disease/advance/A)
	if(A.properties["stage_rate"] >= 6) //stronger healing
		power = 2

/datum/symptom/heal/brute/Heal(mob/living/carbon/M, datum/disease/advance/A)
	var/heal_amt = 1 * power
	var/list/parts = M.get_damaged_bodyparts(1,1) //1,1 because it needs inputs.

	if(!parts.len)
		return

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, 0))
			M.update_damage_overlays()

	return TRUE

/datum/symptom/heal/superbrute
	name = "Flesh Mending"
	desc = "The virus rapidly mutates into body cells, effectively allowing it to quickly fix the host's wounds."
	stealth = 0
	resistance = 0
	stage_speed = -2
	transmittable = -2
	level = 6
	threshold_desc = "<b>Stage Speed 6:</b> Doubles healing speed."

/datum/symptom/heal/superbrute/Start(datum/disease/advance/A)
	if(A.properties["stage_rate"] >= 6) //stronger healing
		power = 2

/datum/symptom/heal/superbrute/Heal(mob/living/carbon/M, datum/disease/advance/A)
	var/heal_amt = 4 * power

	var/list/parts = M.get_damaged_bodyparts(1,1) //1,1 because it needs inputs.

	if(M.getCloneLoss() > 0)
		M.adjustCloneLoss(-1)
		M.take_bodypart_damage(0, BURN) //Deals BURN damage, which is not cured by this symptom

	if(!parts.len)
		return

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(heal_amt/parts.len, 0))
			M.update_damage_overlays()

	return TRUE

/datum/symptom/heal/burn
	name = "Tissue Regrowth"
	desc = "The virus recycles dead and burnt tissues, speeding up the healing of damage caused by burns."
	stealth = 1
	resistance = -2
	stage_speed = -2
	transmittable = -2
	level = 6
	threshold_desc = "<b>Stage Speed 6:</b> Doubles healing speed."

/datum/symptom/heal/burn/Start(datum/disease/advance/A)
	if(A.properties["stage_rate"] >= 6) //stronger healing
		power = 2

/datum/symptom/heal/burn/Heal(mob/living/carbon/M, datum/disease/advance/A)
	var/heal_amt = 1 * power

	var/list/parts = M.get_damaged_bodyparts(1,1) //1,1 because it needs inputs.

	if(!parts.len)
		return

	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(0, heal_amt/parts.len))
			M.update_damage_overlays()

	return TRUE

/datum/symptom/heal/heatresistance
	name = "Heat Resistance"
	desc = "The virus quickly balances body heat, while also replacing tissues damaged by external sources."
	stealth = 0
	resistance = 0
	stage_speed = -2
	transmittable = -2
	level = 4
	threshold_desc = ""
	var/temp_rate = 4

/datum/symptom/heal/heatresistance/Heal(mob/living/carbon/M, datum/disease/advance/A)
	var/heal_amt = 4 * power

	var/list/parts = M.get_damaged_bodyparts(1,1) //1,1 because it needs inputs.

	if(M.bodytemperature > BODYTEMP_NORMAL)	//Shamelessly stolen from plasma fixation, whew lad
		M.adjust_bodytemperature(-20 * temp_rate * TEMPERATURE_DAMAGE_COEFFICIENT,BODYTEMP_NORMAL)
	else if(M.bodytemperature < (BODYTEMP_NORMAL + 1))
		M.adjust_bodytemperature(20 * temp_rate * TEMPERATURE_DAMAGE_COEFFICIENT,0,BODYTEMP_NORMAL)
	for(var/obj/item/bodypart/L in parts)
		if(L.heal_damage(0, heal_amt/parts.len))
			M.update_damage_overlays()

	return TRUE

/datum/symptom/heal/dna
	name = "Deoxyribonucleic Acid Restoration"
	desc = "The virus repairs the host's genome, purging negative mutations."
	stealth = -1
	resistance = -1
	stage_speed = 0
	transmittable = -1
	level = 5
	threshold_desc = "<b>Stage Speed 6:</b> Additionally heals brain damage."
	var/healing_brain = FALSE

/datum/symptom/heal/dna/Start(datum/disease/advance/A)
	if(A.properties["stage_rate"] >= 6) //stronger healing
		healing_brain = TRUE


/datum/symptom/heal/dna/Heal(mob/living/carbon/M, datum/disease/advance/A)
	var/amt_healed = 2
	if(healing_brain)
		M.adjustBrainLoss(-amt_healed)
		var/mob/living/carbon/C = M
		if(prob(40))
			C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_LOBOTOMY)
	//Non-power mutations, excluding race, so the virus does not force monkey -> human transformations.
	var/list/unclean_mutations = (GLOB.not_good_mutations|GLOB.bad_mutations) - GLOB.mutations_list[RACEMUT]
	M.dna.remove_mutation_group(unclean_mutations)
	M.radiation = max(M.radiation - (2 * amt_healed), 0)
	return TRUE

