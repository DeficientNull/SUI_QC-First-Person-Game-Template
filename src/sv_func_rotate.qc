// code based on jaycie erysdren's "func rotate"
// found here https://erysdren.me/docs/rotating-brushes/
.float speedx;
.float speedy;
.float speedz;
.float wait;
.float is_rotating;
.string targetname;
.string target;

void func_rotate_use()
{
	self.is_rotating = 1;
	self.wait = 0;
}

void func_rotate_think()
{
	if (self.wait == -1 && !self.is_rotating)
	{
		self.nextthink = self.ltime + 0.1;
		return;
	}

	// do rotations
	self.avelocity.x = self.speedx;
	self.avelocity.y = self.speedy;
	self.avelocity.z = self.speedz;

	if (self.wait == -1)
	{
		self.is_rotating = 0;
	}

	self.nextthink = self.ltime + 0.1;
}

void func_rotate()
{
	// setup brush model
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setorigin(self, self.origin);
	setmodel(self, self.model);

	// Initialize rotation state
	self.is_rotating = 1;
	if (self.wait == -1)
		self.is_rotating = 0;
	self.use = func_rotate_use;

	// start thinking
	self.think = func_rotate_think;
	self.nextthink = self.ltime + 0.1;
}
