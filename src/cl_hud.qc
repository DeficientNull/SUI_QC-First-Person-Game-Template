float alpha_fade = 0f;

void() draw_fade =
{
//	sui_fill();
	if (is_fadingin == 1) {
		print("fading in");
		
		//when done, disable this part of the function
		is_fadingin = 0;
	}
	if (is_fadingout == 1) {
		print("fading out");

		// same thing as above if statement
		is_fadingout = 0;
	}
}
