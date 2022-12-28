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
//returns true on success, or if training already happened today
//returns false on errors
boolean c2t_trainRando() {
	string prop = "_c2t_trainRandoDone";

	if (item_amount($item[crimbo training manual]) == 0) {
		c2t_trainRandoMsg("crimbo training manual not found","red");
		return false;
	}
	if (get_property(prop).to_boolean()) {
		c2t_trainRandoMsg("trained a rando already today");
		return true;
	}

	buffer buf = visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=11046`,false,true);

	if (buf.contains_text("You've already trained somebody today.")) {
		c2t_trainRandoMsg("Crimbo training manual already used today");
		set_property(prop,"true");
		return true;
	}

	string [int] list = file_to_array("c2t_trainRandoTargets.txt");
	int size = list.count();
	if (size < 2) {//decidedly not a list; also, random() breaks if less than 2
		c2t_trainRandoMsg("the list is too short to be a list","red");
		c2t_trainRandoMsg("there is no list provided by default anymore, so that may be why you are seeing this error","red");
		return false;
	}
	int start = random(size)+1;
	int needle = start;
	string target;
	int miss = 0;

	repeat {
		target = list[needle];
		buf = visit_url(`curse.php?pwd&action=use&whichitem=11046&targetplayer={target}`,true,true);
		//"You train <playername>."
		if (buf.contains_text('<table><tr><td>You train ')) {
			c2t_trainRandoMsg(`trained "{target}"`,"blue");
			if (miss > 0)
				c2t_trainRandoMsg(`tried to train {miss} people before finding a valid target`);
			set_property(prop,"true");
			return true;
		}
		//errors
		else
			miss++;

		if (++needle > size)
			needle = 1;
	} until (needle == start);

	c2t_trainRandoMsg("Tried to train everyone on the list and failed. Probably don't run this again until the list is updated.","red");
	set_property(prop,"true");//don't run again today
	return false;
}

//for the CLI
void main() c2t_trainRando();

