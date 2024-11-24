/*
void() trigger_example =
{
	setmodel(self, self.model);
	self.modelindex = 0;
	self.solid = SOLID_TRIGGER;
	self.touch = something;
};
*/

void() info_null =
{
};

void() func_illusionary =
{
	setmodel(self, self.model);
	self.solid = SOLID_NOT;
};

void() func_wall =
{
    self.solid = SOLID_BSP;
    self.movetype = MOVETYPE_PUSH;  // so it doesn't get pushed by other entities
    setmodel(self, self.model);
    self.model = "";               // no client model needed
};

void() func_detail =
{
    self.solid = SOLID_BSP;
    setmodel(self, self.model);
    self.model = "";               // no client model needed
};
