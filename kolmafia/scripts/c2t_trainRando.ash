//c2t trainRando
//c2t

since r27002;//crimbo training manual item


//formatted messages
void c2t_trainRandoMsg(string s,string c) {
	print(`c2t_trainRando: {s}`,c);
}
void c2t_trainRandoMsg(string s) {
	c2t_trainRandoMsg(s,"");
}

//for importing
void c2t_trainRando() {
	string prop = "_c2t_trainRandoDone";

	if (item_amount($item[crimbo training manual]) == 0) {
		c2t_trainRandoMsg("crimbo training manual not found","red");
		return;
	}
	if (get_property(prop).to_boolean()) {
		c2t_trainRandoMsg("trained a rando already today");
		return;
	}

	buffer buf = visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=11046`,false,true);

	if (buf.contains_text("You've already trained somebody today.")) {
		c2t_trainRandoMsg("Crimbo training manual already used today");
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
			c2t_trainRandoMsg(`trained "{target}"`,"blue");
			if (miss > 0)
				c2t_trainRandoMsg(`tried to train {miss} people before finding a valid target`);
			set_property(prop,"true");
			return;
		}
		//"They already know that skill."
		else if (buf.contains_text("They already know that skill.")) {
			miss++;
			//c2t_trainRandoMsg(`already known by "{target}"`);
		}
		//not a valid player
		else if (buf.contains_text("That player could not be found.")) {
			miss++;
			c2t_trainRandoMsg(`"{target}" could not be found; trying the next...`);
		}
		//other errors
		else {
			miss++;
			c2t_trainRandoMsg(`unknown result from "{target}"; printing result:`,"red");
			print(buf);
		}
		
		if (++needle > size)
			needle = 1;
	} until (needle == start);

	c2t_trainRandoMsg("Tried to train everyone on the list and all failed. Probably don't run this again until the list is updated.","red");
}

//for the CLI
void main() c2t_trainRando();

