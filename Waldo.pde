/*
* TODO:
*	- Modularize Viewport code: Want participants to walk up to screen and spawn viewport at touchpoint
*	- Enable independent X and Y resizing of Viewport
*	- Monitor/Restrict content resizing
*
*/

import vialab.SMT.*;

/*******************************************************************************************/
// 										Global Variables
/*******************************************************************************************/

int screenWidth  = 1920*4;  // 1920*3
int screenHeight = 1080*2;  // 1080*2

final int TEXT_SIZE = 36;	// pixels

final int DISTINCT_WALDO_IMAGES = 3;
final int STARTING_RESOLUTION_LEVEL = 5;
PImage[] waldo_images = new PImage[ DISTINCT_WALDO_IMAGES ];
int curWaldoSet = 0;
int curWaldoRes = 1;

/*******************************************************************************************/
// 										Custom Classes
/*******************************************************************************************/
public class Viewport extends NewTextureZone
{
	final String ID;

	Viewport( int id, int x, int y, int width, int height, String renderer )
	{
		ID = "Viewport" + id;
		super( ID, x, y, width, height, renderer );
	}

	Viewport( int id, int x, int y, int width, int height, String renderer, Zone initialContent )
	{
		ID = "Viewport" + id;
		addContent( initialContent );
		super( name, x, y, width, height, renderer );
	}

	void addContent( Zone content )
	{
		SMT.addChild( ID, content );
	}

}

public class NewTextureZone extends TextureZone
{
	NewTextureZone( String name, int x, int y, int width, int height, String renderer )
	{
		super( name, x, y, width, height, renderer );
	}

	@Override
	public void beginDraw()
	{
		super.beginDraw();
		smooth(0);
		textMode( MODEL );
	}
}

/*******************************************************************************************/
// 									Init & Setup Methods
/*******************************************************************************************/
//  We use init here to allow us to remove the Window's decorations
//  before it is too late in the Setup method
//
//  This is a work around for not being able to use the fullScreen mode
//  across multiple displays
//
public void init()
{
	// to make a frame not displayable, you can
	// use frame.removeNotify()
	frame.removeNotify();
	frame.setUndecorated(true);

	super.init();

	// Pre-load Where's Waldo images
	for ( int i = 0; i < DISTINCT_WALDO_IMAGES; i++ )
	{
		waldo_images[i] = loadImage( "Pix/" + (i+1) + "/original.jpg" );
	}

}

void setup()
{
	// Place the window in the top left corner,
	// and make sure that it's always on top
	// frame.setAlwaysOnTop(true);
	frame.setLocation(0,0);
	size( screenWidth, screenHeight, OPENGL );
	SMT.init(this, TouchSource.MULTIPLE);
	SMT.setWarnUnimplemented( false );

	// Set text-size (px)
	textSize( TEXT_SIZE );

	// Create Viewport
	// TextureZone tz = new NewTextureZone( "Viewport", screenWidth/4, screenHeight/4, screenWidth/4, screenHeight/4, SMT.defaultRenderer );
	// SMT.add( tz );

	// SMT.addChild( "Viewport", waldo );

	Viewport view1 = new Viewport( 0, screenWidth/4, screenHeight/4, screenWidth/4, screenHeight/4, SMT.defaultRenderer );

	// Load initial waldo image into ImageZone
	ImageZone waldo = new ImageZone( "Waldo", waldo_images[curWaldoSet] );

	// Add waldo image to first viewport
	view1.addContent( waldo );

	// Add first viewport to SMT
	SMT.add( view1 );



	/*
	 *	Sliders are all on fourth screen in a vertical column
	 *		4 sliders:
	 *			-Viewport width
	 *			-Viewport height
	 *			-Waldo res
	 *			-Waldo set
	 *	Each slider is contained in a moveable Parent Zone that also contains a label
	 */

	// SliderZone( name, x, y, width, height, currentValue, minValue, maxValue, minorTickSpacing, majorTickSpacing, label )
	int sliderParentWidth  = 700;
	int sliderParentHeight = 300;
	int sliderWidth        = (screenWidth/4)  / 3;
	int sliderHeight       = (screenHeight/2) / 8;
	int fourthScreenX      = 3*screenWidth/4 + sliderWidth;

	// Slider Parent Zones
	SMT.add( new Zone( "ViewportWidthParent",  fourthScreenX, (int)( sliderParentHeight*0 ),   sliderParentWidth, sliderParentHeight ) );
	SMT.add( new Zone( "ViewportHeightParent", fourthScreenX, (int)( sliderParentHeight*1.5 ), sliderParentWidth, sliderParentHeight ) );
	SMT.add( new Zone( "WaldoResParent",       fourthScreenX, (int)( sliderParentHeight*3 ),   sliderParentWidth, sliderParentHeight ) );
	SMT.add( new Zone( "WaldoSetParent",       fourthScreenX, (int)( sliderParentHeight*4.5 ), sliderParentWidth, sliderParentHeight ) );

	// Add viewportWidth Slider
	SliderZone viewportWidth =  new SliderZone( "ViewportWidth", 25, 100, sliderWidth, 200, screenWidth/4, screenWidth/8, 2*screenWidth/5,
												screenWidth/20, screenWidth/10, "Viewport Width" );
	SMT.addChild( "ViewportWidthParent", viewportWidth );

	// Add viewportHeight Slider
	SliderZone viewportHeight = new SliderZone( "ViewportHeight", 25, 100, sliderWidth, 200, screenHeight/4, screenHeight/8, 4*screenHeight/5,
												screenWidth/20, screenWidth/10, "Viewport Height" );
	SMT.addChild( "ViewportHeightParent", viewportHeight );

	// Add waldoRes Slider
	SliderZone waldoRes = new SliderZone( "WaldoRes", 25, 100, sliderWidth, 200, STARTING_RESOLUTION_LEVEL, 1, 10, 1, 1, "Waldo Resolution" );
	SMT.addChild( "WaldoResParent", waldoRes );

	// Add waldoSet Slider
	SliderZone waldoSet = new SliderZone( "WaldoSet", 25, 100, sliderWidth, 200, curWaldoSet, 0, 2, 1, 1, "Waldo Image Set" );
	SMT.addChild( "WaldoSetParent", waldoSet );
}


//************************
//*  PROCESSING METHODS
//************************

void draw()
{
	background(79, 129, 189);
}

//***************************
//*   CONTENT ZONE METHODS
//***************************

// Viewport (TextureZone) Methods:

void drawViewport( Zone z )
{
	background( 0, 0, 0 );
}

void touchViewport( TextureZone tz )
{
	// tz.rst();
	tz.drag();
}

// Waldo (ImageZone) Methods


void touchWaldo( Zone z )
{
	z.drag();
	// z.rst();
//  z.drag( true, true, true, true, -z.width + z.width/20, 2*z.width - z.width/20, -z.height + z.height/20, 2*z.height - z.height/10 );
}

// Slider and Slider Parent Methods:

void drawViewportWidthParent( Zone z )
{
	background( 200, 20, 200 );
	text( "Viewport Width", z.width/3, TEXT_SIZE );
}

void drawViewportHeightParent( Zone z )
{
	background( 200, 20, 200 );
	text( "Viewport Height", z.width/3, TEXT_SIZE );
}

void drawWaldoResParent( Zone z )
{
	background( 200, 20, 200 );
	text( "Waldo Image Resolution", z.width/3, TEXT_SIZE );

}

void drawWaldoSetParent( Zone z )
{
	background( 200, 20, 200 );
	text( "Waldo Scene Selection", z.width/3, TEXT_SIZE );
}

//***************************
//*   SLIDER ZONE METHODS
//***************************


// void touchUpViewportWidth( SliderZone s, Touch t )
// {
// 	boolean changeWidth = true;
// 	adjustViewportDimension( changeWidth, s.getCurrentValue() );
// }

void touchMovedViewportWidth( SliderZone s, Touch t )
{
	boolean changeWidth = true;
	adjustViewportDimension( changeWidth, s.getCurrentValue() );
}

// void touchUpViewportHeight( SliderZone s, Touch t )
// {
// 	boolean changeWidth = false;
// 	adjustViewportDimension( changeWidth, s.getCurrentValue() );
// }

void touchMovedViewportHeight( SliderZone s, Touch t )
{
	boolean changeWidth = false;
	adjustViewportDimension( changeWidth, s.getCurrentValue() );
}

int resolutionLevel = STARTING_RESOLUTION_LEVEL;

void touchUpWaldoRes( SliderZone s, Touch t )
{
	boolean changingResolution = true;
	resolutionLevel = s.getCurrentValue();
	changeImageZone( changingResolution, resolutionLevel );
}

void touchUpWaldoSet( SliderZone s, Touch t )
{
	boolean changingResolution = false;
	changeImageZone( changingResolution, s.getCurrentValue() );
}

//*********************
//*   HELPER METHODS
//*********************

void adjustViewportDimension( boolean changingWidth, int newVal )
{
	// Preserve ImageZone
	ImageZone waldo = (ImageZone)SMT.get( "Viewport" ).getChild( 0 );

	// Capture information before deletion
	TextureZone oldViewport = (TextureZone)SMT.get( "Viewport" );

	int oldHeight 	= oldViewport.getHeight();
	int oldWidth  	= oldViewport.getWidth();
	int oldX      	= oldViewport.getX();
	int oldY      	= oldViewport.getY();

	SMT.remove( "Viewport" );
	// Create new viewport
	// if ( ( newVal - oldHeight ) >= 20 || ( newVal - oldWidth ) >= 20 )
	// {
		if ( changingWidth )
		{
			// if ( newVal <= waldo.getWidth() )
			// {
				oldViewport.setData( oldX, oldY, newVal, oldHeight );
			// }
		}
		else
		{
			// if ( newVal <= waldo.getHeight() )
			// {
				oldViewport.setData( oldX, oldY, oldWidth, newVal );
			// }
		}
	// }

	SMT.add( oldViewport );

}

void changeImageZone( boolean changingResolution, int index )
{
	ImageZone waldo = (ImageZone)SMT.get( "Viewport" ).getChild( 0 );
	SMT.removeChild( "Viewport", waldo );

	if ( changingResolution )
	{
		PImage img = (PImage)waldo_images[curWaldoSet].get();
		img.resize( (int)( (double)img.width * (double)((double)index/(double)STARTING_RESOLUTION_LEVEL) ), 0 );
		waldo = new ImageZone( "Waldo", img );

		// Track resolution level for switching between waldo scenes
		resolutionLevel = index;
	}
	else
	{
		PImage img = (PImage)waldo_images[index].get();
		img.resize( (int)( (double)img.width * (double)((double)resolutionLevel/(double)STARTING_RESOLUTION_LEVEL) ), 0 );
		waldo = new ImageZone( "Waldo", img );

		// Track current Waldo scene in used
        curWaldoSet = index;
	}
	SMT.addChild( "Viewport", waldo );
}




// @TODO
//	WANTS
//  - Define 5 as some kind of constant for (global res var and initializing first waldo image and resizing)
//	- If I could scope resolutionLeve and curWaldoSet within that function (functor?)

