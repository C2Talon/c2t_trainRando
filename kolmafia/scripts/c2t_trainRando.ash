//c2t trainRando
//c2t


void c2t_trainRando() {
	string prop = "_c2t_trainRandoDone";

	if (get_property(prop).to_boolean()) {
		print("c2t_trainRando: rando trained already");
		return;
	}

	buffer buf = visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=11046`,false,true);

	if (buf.contains_text("You've already trained somebody today.")) {
		print("c2t_trainRando: Crimbo training manual already used today");
		set_property(prop,"true");
		return;
	}

	string [int] list = file_to_array("c2t_trainRandoTargets.txt");
	int size = list.count();
	int start = random(size)+1;
	int needle = start;
	string target;
	int miss = 0;

	repeat {
		target = list[needle];
		buf = visit_url(`curse.php?pwd&action=use&whichitem=11046&targetplayer={target}`,true,true);
		//"You train <playername>."
		if (buf.contains_text('<b>Results:</b></td></tr><tr><td style="padding: 5px; border: 1px solid blue;"><center><table><tr><td>You train ')) {
			print(`c2t_trainRando: taught the skill to "{target}"`,"blue");
			if (miss > 0)
				print(`c2t_trainRando: tried to teach {miss} people before finding a valid target`);
			set_property(prop,"true");
			return;
		}
		//"They already know that skill."
		else if (buf.contains_text("They already know that skill.")) {
			miss++;
			//print(`c2t_trainRando: already known by "{target}"`);
		}
		//not a valid player? other errors?
		else {
			miss++;
			print(`c2t_trainRando: unknown result from "{target}"; printing result:`,"red");
			print(buf);
		}
		
		if (++needle > size)
			needle = 1;
	} until (needle == start);

	print("c2t_trainRando: Tried to teach everyone on the list and all failed. Probably don't run this again until you update the list.","red");
}

void main() c2t_trainRando();

