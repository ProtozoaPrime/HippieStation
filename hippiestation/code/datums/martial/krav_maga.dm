/datum/martial_art/krav_maga/leg_sweep(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(D.stat || D.IsKnockdown())
		return 0
	D.visible_message("<span class='warning'>[A] leg sweeps [D]!</span>", \
					  	"<span class='userdanger'>[A] leg sweeps you!</span>")
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, 1, -1)
	D.apply_damage(5, BRUTE)
	D.Knockdown(20)
	add_logs(A, D, "leg sweeped")
return 1

/datum/martial_art/krav_maga/quick_choke(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)//is actually lung punch
	D.visible_message("<span class='warning'>[A] pounds [D] on the chest!</span>", \
				  	"<span class='userdanger'>[A] slams your chest! You can't breathe!</span>")
	playsound(get_turf(A), 'sound/effects/hit_punch.ogg', 50, 1, -1)
	if(D.losebreath <= 10)
		D.losebreath = Clamp(D.losebreath + 2, 0, 10)
	D.adjustOxyLoss(10)
	add_logs(A, D, "quickchoked")
	return 1
