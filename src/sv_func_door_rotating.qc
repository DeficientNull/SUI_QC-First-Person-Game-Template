static enum {
    STATE_CLOSED,
    STATE_OPEN,
    STATE_CLOSING,
    STATE_OPENING,
};

static enumflags {
    START_OPEN,
    USABLE
};

.float speed;
.float lip;
.float distance;
.float state;
.float angle_closed;
.float angle_open;
.vector rotateaxis;
.vector rotation_origin;  // Store the rotation origin point

.float is_moving;

void() func_door_rotating_setup =
{
    // calculate rotation axis
    makevectors(self.angles);
    self.rotateaxis = v_forward;  // Default to rotating around X axis
    self.angles = [0, 0, 0];
    
    // defaults
    if (self.speed <= 0) self.speed = 100;
    if (self.distance <= 0) self.distance = 90;  // Default 90 degree rotation
    if (self.wait == 0) self.wait = 3;
    
    // Find origin brush if it exists
    entity origin_ent = find(world, targetname, self.target);
    if (origin_ent)
    {
        // Store the rotation origin point
        self.rotation_origin = origin_ent.origin;
        // Remove the origin brush entity
        remove(origin_ent);
    }
    else
    {
        // If no origin brush found, rotate around entity's origin
        self.rotation_origin = self.origin;
    }
    
    // calculate angles
    self.angle_closed = self.angles_y;
    self.angle_open = self.angles_y + self.distance;
}

void() func_door_rotating_null =
{
    // no op
}

void() func_door_rotating_done =
{
    if (self.state == STATE_CLOSING)
        self.state = STATE_CLOSED;
    else if (self.state == STATE_OPENING)
        self.state = STATE_OPEN;
        
    self.avelocity = '0 0 0';  // Stop rotation
}

void() func_door_rotating_return =
{
    // do sound
    if (self.noise)
        sound(self, CHAN_BODY, self.noise, 10, ATTN_NORM);
    
    // Set rotation velocity based on state
    if (self.state == STATE_OPEN)
    {
        self.state = STATE_CLOSING;
        self.avelocity_y = -self.speed;  // Rotate back at closing speed
        self.think = func_door_rotating_done;
        self.nextthink = self.ltime + (self.distance / self.speed);
    }
    else if (self.state == STATE_CLOSED)
    {
        self.state = STATE_OPENING;
        self.avelocity_y = self.speed;  // Rotate at opening speed
        self.think = func_door_rotating_done;
        self.nextthink = self.ltime + (self.distance / self.speed);
    }
}

void() func_door_rotating_wait =
{
    if (self.state == STATE_CLOSING)
        self.state = STATE_CLOSED;
    else if (self.state == STATE_OPENING)
        self.state = STATE_OPEN;
    
    self.avelocity = '0 0 0';  // Stop rotation while waiting
    
    if (self.wait < 0)
    {
        self.nextthink = self.ltime + 0.1;
        self.think = func_door_rotating_null;
    }
    else
    {
        self.nextthink = self.ltime + self.wait;
        self.think = func_door_rotating_return;
    }
}

void() func_door_rotating_use =
{
    // if we're moving, return
    if (self.state == STATE_OPENING || self.state == STATE_CLOSING)
        return;
    
    // do sound
    if (self.noise)
        sound(self, CHAN_BODY, self.noise, 10, ATTN_NORM);
    
    // Set rotation velocity based on state
    if (self.state == STATE_OPEN)
    {
        self.state = STATE_CLOSING;
        self.avelocity_y = -self.speed;  // Rotate back at closing speed
        self.think = func_door_rotating_wait;
        self.nextthink = self.ltime + (self.distance / self.speed);
    }
    else if (self.state == STATE_CLOSED)
    {
        self.state = STATE_OPENING;
        self.avelocity_y = self.speed;  // Rotate at opening speed
        self.think = func_door_rotating_wait;
        self.nextthink = self.ltime + (self.distance / self.speed);
    }
}

void() func_door_rotating =
{
       // Setup physics/collision
    self.movetype = MOVETYPE_PUSH;
    self.solid = SOLID_BSP;
    setmodel(self, self.model);
    
    func_door_rotating_setup();

    // setup
    // precache sound
    if (self.noise)
        precache_sound(self.noise);
    
    // set use function
    self.use = func_door_rotating_use;
    
    // set initial state and position
    if (self.spawnflags & START_OPEN)
    {
        self.state = STATE_OPEN;
        self.angles_y = self.angle_open;
    }
    else
    {
        self.state = STATE_CLOSED;
        self.angles_y = self.angle_closed;
    }
    
    // set usable flag if needed
    if (self.spawnflags & USABLE)
        self.flags |= FL_USABLE;
}
