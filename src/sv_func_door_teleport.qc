.string target;        // Target destination entity
.string targetname;    // For targeting this door

vector user_origin;
.vector destination_origin;

void() func_door_teleport_use =
{
    // Find destination entity
    entity dest = find(world, targetname, self.target);
    if (!dest)
    {
        print("func_door_teleport: no destination found\n");
        return;
    }
    
    // do sound
    if (self.noise)
        sound(self, CHAN_BODY, self.noise, 10, ATTN_NORM);
    // Teleport the activator to destination
    setorigin(activator, dest.origin);
    activator.angles = dest.angles;  // Also set view angles
};

void() func_door_teleport =
{
    // Setup physics/collision
    self.movetype = MOVETYPE_NONE;
    self.solid = SOLID_BSP;
    setmodel(self, self.model);
    
    // set use function
    self.use = func_door_teleport_use;
    
    // set usable flag if needed
    if (self.spawnflags & USABLE)
        self.flags |= FL_USABLE;
};

/*QUAKED teleport_destination (.5 .5 .5) (-16 -16 -16) (16 16 16)
Destination entity for func_door_teleport.
-------- KEYS --------
targetname : Name that func_door_teleport targets
angles : View angles the player will face after teleporting
*/
void() teleport_destination =
{
    // This is just a point entity, no model needed
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
};
