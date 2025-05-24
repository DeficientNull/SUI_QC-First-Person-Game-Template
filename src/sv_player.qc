//
//	Player.qc - Various stuff done for the player, including per-frame functions like PlayerPreThink and PlayerPostThink, also client specific stuff like PutClientInServer etc.
//

void() PlayerJump =
{
	if (!(self.flags & FL_ONGROUND))
		return;

	if ( !(self.flags & FL_JUMPRELEASED) )
		return;
	
	self.weaponframe = 0;
	self.velocity_z = 295;
	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
	self.button2 = 0;
};

const float STANDING_HEIGHT = 64;
const float CROUCHING_HEIGHT = 44;
const float STANDING_VIEWOFS = 52;
const float CROUCHING_VIEWOFS = 32;

void() PlayerUse = 
{
    if (self.button4) 
    {
        vector source;
        vector end;
        
        makevectors(self.v_angle);
        source = self.origin + self.view_ofs;  // Adjust for player's view height
        end = source + v_forward * 64;    // Use range of 64 units
        
        traceline(source, end, MOVE_NORMAL, self);
        
        if (trace_fraction < 1.0)
        {
            entity found = trace_ent;
            if (found.use != __NULL__)
            {
		activator = self;
		do_as_self(found, found.use);
                //print("Used entity at distance: ");
                //print(ftos(trace_fraction * 96));
                //print("\n");
            } else {
		print("use could not find entity");
	    }
        }
    }
}

void() CheckImpulses =
{
	switch (self.impulse)
	{
	default: break;
	}
	self.impulse = 0;
};

vector() get_spawn_point =
{
	entity spawnpoint = world;
	spawnpoint = find(spawnpoint, classname, "info_player_start");

	return spawnpoint.origin + '0 0 1';
};

void() PlayerCrouch =
{
    if (self.button8) // button8 from client
    {
        if (!(self.flags & FL_CROUCHING))
        {
            self.flags = self.flags | FL_CROUCHING;
            setsize(self, '-16 -16 0', '14 14 30');
            self.view_ofs = '0 0 28';
            self.maxspeed = 110; // Half speed while crouching
        }
    }
    else if (self.flags & FL_CROUCHING)
    {
        // Check if we can stand up (no obstacles above)
        tracebox(self.origin, '-16 -16 0', '16 16 64', self.origin, MOVE_NORMAL, self);
        if (!trace_allsolid)
        {
            self.flags = self.flags - (self.flags & FL_CROUCHING);
            setsize(self, '-16 -16 0', '14 14 64');
            self.view_ofs = '0 0 52';
            self.maxspeed = 220; // Normal speed
        }
    }
};
/* Lantern style flashlight implementation
void() PlayerFlashlight =
{
    // Check if F key is pressed (button7)
    if (self.button7)
    {
        if (!self.enemy)  // No flashlight exists
        {
            // Create rtlight for flashlight using dynamiclight_spawnstatic
            self.enemy = dynamiclight_spawnstatic(self.origin, 300, '1 1 1', 0);
            // Set it as a spotlight
            dynamiclight_set(self.enemy, LFIELD_ANGLES, self.v_angle);
            dynamiclight_set(self.enemy, LFIELD_FOV, 60);
            dynamiclight_set(self.enemy, LFIELD_FLAGS, LFLAG_NOSHADOW | LFLAG_DYNAMIC);
        }

        // Update rtlight position and direction (predraw)
        makevectors(self.v_angle);
        dynamiclight_set(self.enemy, LFIELD_ORIGIN, self.origin + v_forward * 2 + '0 0 16');
        dynamiclight_set(self.enemy, LFIELD_ANGLES, self.v_angle);
    }
    else if (self.enemy)  // F key not pressed but light exists
    {
        // Remove the rtlight
        remove(self.enemy);
        self.enemy = world;
    }
};
*/
void() PlayerPreThink =
{	
    CheckImpulses();
    makevectors(self.v_angle);
    PlayerCrouch();
    PlayerUse();
    //PlayerFlashlight();  // Add flashlight check
    if(self.button2)
    {
        PlayerJump();
   }
    else
    {
        self.flags = self.flags | FL_JUMPRELEASED;
    }
};

void() PlayerPostThink =
{
};

void() ClientKill =
{
};

//called when a client connects to the server
void() ClientConnect =
{
	// print("Client connect\n");
};

void() PlayerSpawn =
{
	self.classname = "player";
	self.solid = SOLID_SLIDEBOX;
	//setmodel(self, "models/testplayer.iqm");
	self.movetype = MOVETYPE_WALK;
	self.health = 100;
	setorigin(self, get_spawn_point());
	self.fixangle = TRUE;
	setsize(self, [-16, -16, 0], [14, 14, 64]);
	self.view_ofs = [0, 0, 52];
	self.maxspeed = 220;
};

void() PutClientInServer =
{
	player_chain_add(self);
	PlayerSpawn();
};

void() ClientDisconnect =
{
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " has left the game.\n");
};


void() SetNewParms =
{
};

void() SetChangeParms =
{
};

void() info_player_start =
{
};

void(float elapsedtime) SV_PausedTic =
{
	// if (elapsedtime > 2) setpause(0);
};

void(string command_string) SV_ParseClientCommand =
{
	tokenize(command_string);
	string cmd = argv(0);
	switch (cmd)
	{
	default: break;
	}
	clientcommand(self, command_string);
};


void() SV_RunClientCommand =
{
	runstandardplayerphysics(self);
};
