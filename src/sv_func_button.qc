/*
    func_button - Interactive button entity
    Features:
    - Can be triggered by touch or use
    - Supports wait time between uses
    - Can trigger targets
    - Optional sounds for press/release
*/

.float button_state;    // 0 = down, 1 = up, 2 = raised
.float wait_time;       // Time before button returns
.float button_speed_x;  // Movement speed X
.float button_speed_y;  // Movement speed Y
.float button_speed_z;  // Movement speed Z
.float button_lip;      // Button travel distance
.vector start_origin;  // Store initial position
.float angle;          // Angle of movement
.string target;        // Target entity to trigger
.string targetname;

//used to keep track of self correctly during targeting
void do_as_self(entity target, void() func)
{
    entity oldself = self;
    self = target;
    func();
    self = oldself;
}

void() button_return =
{
    print("button returning");
    self.button_state = 0;
    
    // Move back to exact starting position
    setorigin(self, self.start_origin);
    self.velocity_x = self.button_speed_x;
    self.velocity_y = self.button_speed_y;
    self.velocity_z = self.button_speed_z;

    if (self.noise2)
        sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
};

void() button_fire =
{
    if (self.button_state == 1 || self.button_state == 2)
        return;

    self.button_state = 1;
    
    print("button fired");
    
    // Move button with velocity
    self.velocity_x = self.button_speed_x;
    self.velocity_y = self.button_speed_y;
    self.velocity_z = self.button_speed_z;
    
    // Trigger target entity
    if (self.target)
    {
        entity t = find(world, targetname, self.target);
        if (t && t.use)
        {
            do_as_self(t, t.use);
            //print("button triggered target");
        }
    }

    // Setup return timer
    if (self.wait_time > 0)
    {
        self.think = button_return;
        self.nextthink = self.ltime + self.wait_time;
    }
    
    if (self.noise1)
        sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
};

void() button_use =
{
    if (self.button_state == 2 || self.button_state == 1)
        return;
    
    self.button_state = 2;
    
    print("button used");

    if (self.noise)
        sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

    button_fire();
};

void() button_touch =
{
    print("button touched");
    button_fire();
 // Check if it's a player by classname
    if (other.classname == "player")
    {
        self.button_state = 2;
    }

    if (self.button_state == 2)
    {
        button_fire();
    }
};

void() func_button =
{
    if (!self.button_speed_x)
        self.button_speed_x = 0;
    if (!self.button_speed_y)
        self.button_speed_y = 0;
    if (!self.button_speed_z)
        self.button_speed_z = 0;
    if (!self.wait_time)
        self.wait_time = 1;
    if (!self.button_lip)
        self.button_lip = 4;

    // Setup physics/collision
    self.movetype = MOVETYPE_PUSH;
    self.solid = SOLID_BSP;
    setmodel(self, self.model);

    // Store initial position
    self.start_origin = self.origin;
    
    self.button_state = 0;  // Start in down position
    self.use = button_use;
    self.touch = button_touch;  // Set the touch function to handle collisions
};
