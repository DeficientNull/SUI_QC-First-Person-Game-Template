// put custom server-only globals and fields here

// Custom flags for the engine
// Flags that aren't in the default engine

const float FL_JUMPRELEASED = 4096;
const float FL_CROUCHING = 8192;  // Using next available power of 2 after FL_JUMPRELEASED

void() sub_remove =
{
	remove(self);
};

void() sub_noop = {};

void(float event) BeginEvent =
{
	WriteByte(MSG_MULTICAST, SVC_CGAMEPACKET);
	WriteByte(MSG_MULTICAST, event);
};

void(vector vec) MulticastVector =
{
	WriteCoord(MSG_MULTICAST, vec_x);
	WriteCoord(MSG_MULTICAST, vec_y);
	WriteCoord(MSG_MULTICAST, vec_z);
};

void(float val) MulticastByte =
{
	WriteByte(MSG_MULTICAST, val);
};

void(float val) MulticastShort =
{
	WriteShort(MSG_MULTICAST, val);
};

void(float val) MulticastFloat =
{
	WriteFloat(MSG_MULTICAST, val);
};

void(entity e) MulticastEnt =
{
	WriteEntity(MSG_MULTICAST, e);
};

void(string s) MulticastString =
{
	WriteString(MSG_MULTICAST, s);
};


entity player_chain_head;
.entity player_chain_next;
.entity player_chain_prev;

// Put an entity as the first of the linked list
void(entity adding) player_chain_add =
{
	if (adding.player_chain_prev || adding.player_chain_next || (adding == player_chain_head && !adding.player_chain_next)) 
	{
		print("Trying to adding an entity into player chain while it already is in chain!\n");
		return;
	}
	if (player_chain_head) player_chain_head.player_chain_prev = adding;
	adding.player_chain_next = player_chain_head;
	player_chain_head = adding;
};

// Remove entity from linked list
void(entity removing) player_chain_remove =
{
	if (removing == player_chain_head)
	{
		player_chain_head = removing.player_chain_next;
	}
	
	if (removing.player_chain_next) removing.player_chain_next.player_chain_prev = removing.player_chain_prev;
	if (removing.player_chain_prev) removing.player_chain_prev.player_chain_next = removing.player_chain_next;
	removing.player_chain_next = world;
	removing.player_chain_prev = world;
};

//used to keep track of self correctly during targeting
void do_as_self(entity target, void() func)
{
    entity oldself = self;
    self = target;
    func();
    self = oldself;
}


//func_door and func_plat setup
//code generously contributed by Jaycie Erysdren 

.void() done;
.vector destination;


// for measuring how large an entity is along an arbitrary vector
// FIXME: this is trash and it returns trash
float(vector v, vector s) bounds_angle_size =
{
	v_x = fabs(v_x);
	v_y = fabs(v_y);
	v_z = fabs(v_z);
	
	// size is always + + + but this is in case I switch the parameters somewhere
	s_x = fabs(s_x);
	s_y = fabs(s_y);
	s_z = fabs(s_z);
	
	return v * s;
}

void bmodel_setup(float solid_type, float move_type)
{
	setorigin(self, self.origin);
	setmodel(self, self.model);
	self.solid = solid_type;
	self.movetype = move_type;
}

void bmodel_calc_move_done()
{
	setorigin(self, self.destination);
	self.velocity = [0, 0, 0];
	self.think = self.done;
	self.nextthink = self.ltime + 0.1;
}

void bmodel_calc_move(vector movedest, float movespeed, void() donefunc)
{
	vector vdestdelta;
	float len, traveltime;

	// check if mvoespeed is valid
	if (movespeed <= 0)
		error("movespeed is 0 or below, which is not valid");

	// set done func
	self.done = donefunc;

	// set think
	self.think = bmodel_calc_move_done;

	// set destination
	self.destination = movedest;

	// check if movedest is valid
	if (movedest == self.origin)
	{
		self.velocity = [0, 0, 0];
		self.nextthink = self.ltime + 0.1;
		return;
	}

	// set destdelta to the vector needed to move
	vdestdelta = movedest - self.origin;

	// calculate length of vector
	len = vlen(vdestdelta);

	// divide by speed to get time to reach dest
	traveltime = len / movespeed;

	// check if travelspeed is valid
	if (traveltime < 0.1)
	{
		self.velocity = [0, 0, 0];
		self.nextthink = self.ltime + 0.1;
		return;
	}

	// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

	// scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1 / traveltime);
}

// from copper
float(float in, float def) zeroconvertdefault =
{
	if (in == -1) return 0;
	if (in == 0) return def;
	return in;
}
