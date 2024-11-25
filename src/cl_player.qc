var int player_movespeed = 220;
var float flashlight_id = 0;  // Store the light ID
var int autocvar_flashlight;

void() PlayerFlashlight =
{
    if(autocvar_flashlight == 1)
    {
        vector porigin = getproperty(VF_ORIGIN);
        vector pangles = getproperty(VF_CL_VIEWANGLES);
        // create the flashlight
        float torch = dynamiclight_add(porigin, 150.0, [1, 1, 1]);
        // set it to face the player's look direction and give it an fov
        dynamiclight_set(torch, LFIELD_ANGLES, pangles);
        dynamiclight_set(torch, LFIELD_FOV, 60.0);
    } if (autocvar_flashlight == 0) 
    {
    }
}

void() CSQC_Input_Frame =
{
    // Clamp movement values
    input_movevalues_x = bound(-player_movespeed, input_movevalues_x, player_movespeed);
    input_movevalues_y = bound(-player_movespeed, input_movevalues_y, player_movespeed);
    input_movevalues_z = bound(-player_movespeed, input_movevalues_z, player_movespeed);

    PlayerFlashlight();  // Call flashlight update
}
