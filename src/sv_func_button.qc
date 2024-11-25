/*
    func_button - Interactive button entity
    Features:
    - Can be triggered by touch or use
    - Supports wait time between uses
    - Can trigger targets
    - Optional sounds for press/release
*/

.float button_state;  // 0 = down, 1 = up, 2 = raised

void() button_return;
void() button_wait;

void() button_fire =
{
    if (self.button_state == 1 || self.button_state == 2)
        return;

    self.button_state = 1;
    SUB_UseTargets();

    if (self.wait > 0) {
        self.think = button_return;
        self.nextthink = time + self.wait;
    }
    
    if (self.noise1)
        sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
};

void() button_use =
{
    if (self.button_state == 2 || self.button_state == 1)
        return;
    
    self.button_state = 2;

    if (self.noise)
        sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

    button_fire();
};

void() button_touch =
{
    if (self.button_state == 2)
        return;
    
    if (!other.flags & FL_CLIENT)
        return;

    self.button_state = 2;
    button_fire();
};

void() button_return =
{
    self.button_state = 0;
    
    if (self.noise2)
        sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
};

void() func_button =
{
    if (!self.speed)
        self.speed = 40;
    if (!self.wait)
        self.wait = 1;
    if (!self.lip)
        self.lip = 4;

    // Setup physics/collision
    self.movetype = MOVETYPE_PUSH;
    self.solid = SOLID_BSP;
    setmodel(self, self.model);

    self.button_state = 0;  // Start in down position
    self.use = button_use;
    self.touch = button_touch;

    if (!self.targetname)
        self.touch = button_touch;
};
