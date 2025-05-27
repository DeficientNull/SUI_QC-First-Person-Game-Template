textures/dev/white
{
	{
		map $nearest:textures/dev/white.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/gray
{
	{
		map $nearest:textures/dev/gray.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/graydark
{
	{
		map $nearest:textures/dev/graydark.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/black
{
	{
		map $nearest:textures/dev/black.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/green
{
	{
		map $nearest:textures/dev/green.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/blue
{
	{
		map $nearest:textures/dev/blue.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/brown
{
	{
		map $nearest:textures/dev/brown.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}
textures/dev/beige
{
	{
		map $nearest:textures/dev/beige.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/orange
{
	{
		map $nearest:textures/dev/orange.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/red
{
	{
		map $nearest:textures/dev/red.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/purple
{
	{
		map $nearest:textures/dev/purple.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/dev/yellow
{
	{
		map $nearest:textures/dev/yellow.tga
		rgbGen identity
	}
	{
		map $lightmap
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
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
	q3map_sun 0.7 0.6 0.8 550 60 45
	
	surfaceparm sky
	surfaceparm noimpact
	surfaceparm nolightmap
	surfaceparm nomarks
	skyparms full 512 -
	{
		map textures/skies/sky25_64.tga
	}
}
