/*
	misc_model - A static model entity that supports multiple model formats
	Supports: .mdl, .spr, and .iqm formats
*/

void() misc_model =
{
	precache_model(self.model);
	
	if (!self.model) {
		objerror("misc_model: no model declared");
		return;
	}
	
	// Check model extension and handle appropriately
	string ext = substring(self.model, strlen(self.model) - 4, 4);
	if (ext == ".mdl" || ext == ".spr" || ext == ".iqm") {
		setmodel(self, self.model);
	} else {
		objerror("misc_model: unsupported model format. Use .mdl, .spr, or .iqm\n");
		return;
	}
	
	// If no specific origin brush, use the entity's origin
	if (!self.origin) {
		setorigin(self, self.origin);
	}
	
	// Make non-solid by default unless specified
	if (!self.solid) {
		self.solid = SOLID_NOT;
	}
	
	// Handle angles if specified
	if (self.angles != '0 0 0') {
		self.angles = self.angles;
	}
	
	// Handle scale if specified (default to 1.0)
	if (!self.scale) {
		self.scale = 1;
	}
};
