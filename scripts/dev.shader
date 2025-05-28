textures/dev/origin
{
	qer_editorImage textures/dev/dev_origin.png

	surfaceparm origin
	surfaceparm nolightmap
	surfaceparm nodlight
	srufaceparm nonsolid
	surfaceparm nodraw
}

textures/dev/playerclip
{
	qer_editorImage textures/dev/dev_clip.png
	
	surfaceparm solid
	surfaceparm nolightmap
	surfaceparm nodlight
	surfaceparm nodraw
}

textures/light/dev_light_white
{
	qer_editorImage textures/light/lighty.png
	qer_lightImage textures/light/lighty.png
	q3map_surfacelight 3000
	{
		map $lightmap
		rgbGen identity
	}
	{
		map textures/light/lighty.png
		blendfunc add
	}
}

textures/light/dev_light_yellow
{
	qer_editorImage textures/light/light_warm.png
	q3map_lightImage textures/light/light_warm.png
	q3map_surfacelight 3000
	{
		map $lightmap
		rgbGen identity
	}
	{
		map textures/light/light_warm.png
		blendfunc add
	}
}

textures/dev/test_sky
{
	qer_editorimage textures/skies/sky25_64.tga

	q3map_globaltexture
	q3map_lightsubdivide 256
	q3map_surfaceLight 120
	q3map_sun 0.4 0.4 0.4 50 60 45
	
	surfaceparm sky
	surfaceparm noimpact
	surfaceparm nolightmap
	surfaceparm nomarks
	skyparms full 512 -
	{
		map textures/skies/sky25_64.tga
	}
}
