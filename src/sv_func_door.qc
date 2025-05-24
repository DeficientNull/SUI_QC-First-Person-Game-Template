static enum {
	STATE_CLOSED,
	STATE_OPEN,
	STATE_CLOSING,
	STATE_OPENING,
};

static enumflags {
	START_OPEN,
	USABLE,
	FL_USABLE
};

.float speed;
.float lip;
.float distance;
.float state;
.vector origin_closed;
.vector origin_open;
.vector movedir;
.float direction;
.float is_moving;


static void func_door_setup(void)
{
	// calculate movedir
	makevectors(self.angles);
	self.movedir = v_forward;
	self.angles = [0, 0, 0];

	// defaults
	if (self.speed <= 0) self.speed = 50;
	if (self.lip == 0) self.lip = 8;
	if (self.wait == 0) self.wait = 3;

	// calculate distance
	self.distance = zeroconvertdefault(self.distance, bounds_angle_size(self.movedir, self.size) - self.lip);

	// calculate positions
	self.origin_closed = self.origin;
	self.origin_open = self.origin + self.movedir * self.distance;
}

static void func_door_null(void)
{
	// null 
}

static void func_door_done(void)
{
	if (self.state == STATE_CLOSING)
		self.state = STATE_CLOSED;
	else if (self.state == STATE_OPENING)
		self.state = STATE_OPEN;
}

static void func_door_return(void)
{
	// do sound
	if (self.noise)
		sound(self, CHAN_BODY, self.noise, 10, ATTN_NORM);

	// do move
	if (self.state == STATE_OPEN)
	{
		self.state = STATE_CLOSING;
		bmodel_calc_move(self.origin_closed, self.speed, func_door_done);
	}
	else if (self.state == STATE_CLOSED)
	{
		self.state = STATE_OPENING;
		bmodel_calc_move(self.origin_open, self.speed, func_door_done);
	}
}

static void func_door_wait(void)
{
	if (self.state == STATE_CLOSING)
		self.state = STATE_CLOSED;
	else if (self.state == STATE_OPENING)
		self.state = STATE_OPEN;

	if (self.wait < 0)
	{
		self.nextthink = self.ltime + 0.1;
		self.think = func_door_null;
	}
	else
	{
		self.nextthink = self.ltime + self.wait;
		self.think = func_door_return;
	}
}

static void func_door_use(void)
{
	// if we're moving, return
	if (self.state == STATE_OPENING || self.state == STATE_CLOSING)
		return;

	// do sound
	if (self.noise)
		sound(self, CHAN_BODY, self.noise, 10, ATTN_NORM);

	// act based on state
	if (self.state == STATE_OPEN)
	{
		self.state = STATE_CLOSING;
		bmodel_calc_move(self.origin_closed, self.speed, func_door_wait);
	}
	else if (self.state == STATE_CLOSED)
	{
		self.state = STATE_OPENING;
		bmodel_calc_move(self.origin_open, self.speed, func_door_wait);
	}
}

static void func_door_touch(void)
{
	// if we're moving, return
	if (self.state == STATE_OPENING || self.state == STATE_CLOSING)
		return;

	// do sound
	if (self.noise)
		sound(self, CHAN_BODY, self.noise, 10, ATTN_NORM);

	// act based on state
	if (self.state == STATE_OPEN)
	{
		self.state = STATE_CLOSING;
		bmodel_calc_move(self.origin_closed, self.speed, func_door_wait);
	}
	else if (self.state == STATE_CLOSED)
	{
		self.state = STATE_OPENING;
		bmodel_calc_move(self.origin_open, self.speed, func_door_wait);
	}
}

void func_door(void)
{
	// setup
	bmodel_setup(SOLID_BSP, MOVETYPE_PUSH);
	func_door_setup();

	// precache sound
	if (self.noise)
		precache_sound(self.noise);

	// set use
	self.use = func_door_use;
	self.touch = func_door_touch;

	// closed by default
	if (self.spawnflags & START_OPEN)
	{
		self.state = STATE_OPEN;
		setorigin(self, self.origin_open);
	}

	// usable by player
	if (self.spawnflags & USABLE)
		self.flags |= FL_USABLE;
}
