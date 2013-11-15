import vialab.SMT.*;

int screenWidth = 1440;  // 1920*3
int screenHeight = 900; // 1080*2
// int screenWidth = 1920*4;  // 1920*3
// int screenHeight = 1080*2; // 1080*2

PImage[][] waldo_images = new PImage[3][3];
int curWaldoSet = 0;
int curWaldoRes = 1;

/*******************************************************************************************/
// Init & Setup Methods
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

	// addNotify, here i am not sure if you have
	// to add notify again.
	//  frame.addNotify();
	// frame.removeNotify();
	super.init();

	// Pre-load Where's Waldo images
	final int DISTINCT_WALDO_IMAGES = 3;
	// final int NUM_RESOLUTION_LEVELS = 3;
	for ( int i = 0; i < DISTINCT_WALDO_IMAGES; i++ )
	{
		waldo_images[i][0] = loadImage( "Pix/" + (i+1) + "/half.jpg" );
		waldo_images[i][1] = loadImage( "Pix/" + (i+1) + "/original.jpg" );
		waldo_images[i][2] = loadImage( "Pix/" + (i+1) + "/double.jpg" );
	}

}

void setup()
{
	// Place the window in the top left corner,
	// and make sure that it's always on top
	// frame.setAlwaysOnTop(true);
	frame.setLocation(0,0);
	size( screenWidth, screenHeight, P3D );
	SMT.init(this, TouchSource.MULTIPLE);
	int waldoWidth = 1700;
	int waldoHeight = 2340;


	// Create Viewport
	TextureZone tz = new TextureZone( "Viewport", screenWidth/4, screenHeight/4, screenWidth/2, screenHeight/2 );
	SMT.add( tz );

	// Load initial Waldo Image into ImageZone
	ImageZone waldo = new ImageZone( "Waldo", waldo_images[curWaldoSet][curWaldoRes] );

	SMT.addChild( "Viewport", waldo );

	// Sliders are all on fourth screen in a vertical column
	//	4 sliders:
	//		-Viewport width
	//		-Viewport height
	//		-Waldo res
	//		-Waldo set

	// SliderZone( name, x, y, width, height, currentValue, minValue, maxValue, minorTickSpacing, majorTickSpacing, label )
	int sliderWidth  = (screenWidth/4)  / 3;
	int sliderHeight = (screenHeight/2) / 8;
	int fourthScreenX = 3*screenWidth/4 + sliderWidth;

	SMT.add( new SliderZone( "ViewportWidth", fourthScreenX, sliderHeight*0, 200, 200, screenWidth/4, screenWidth/8, screenWidth/2,
								screenWidth/20, screenWidth/10, "Viewport Width" ) );

	SMT.add( new SliderZone( "ViewportHeight", fourthScreenX, sliderHeight*1, 200, 200, screenWidth/4, screenWidth/8, screenWidth/2,
								screenWidth/20, screenWidth/10, "Viewport Height" ) );

	SMT.add( new SliderZone( "WaldoRes", fourthScreenX, sliderHeight*2, 200, 200, 1, 0, 2,
								1, 1, "Waldo Resolution" ) );

	SMT.add( new SliderZone( "WaldoSet", fourthScreenX, sliderHeight*3, 200, 200, curWaldoSet, 0, 2,
								1, 1, "Waldo Image Set" ) );

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

}

void touchViewport( TextureZone tz )
{
	tz.drag();
}

// Waldo (ImageZone) Methods

void touchWaldo( Zone z )
{
	z.rnt();
//  z.drag( true, true, true, true, -z.width + z.width/20, 2*z.width - z.width/20, -z.height + z.height/20, 2*z.height - z.height/10 );
}

//***************************
//*   CONTROL ZONE METHODS
//***************************


void touchUpViewportWidth( SliderZone s, Touch t )
{
	boolean changeWidth = true;
	adjustViewportDimension( changeWidth, s.getCurrentValue() );
}

void touchUpViewportHeight( SliderZone s, Touch t )
{
	boolean changeWidth = false;
	adjustViewportDimension( changeWidth, s.getCurrentValue() );
}

void touchUpWaldoRes( SliderZone s, Touch t )
{
	boolean changingResolution = false;
	changeImageZone( changingResolution, s.getCurrentValue() );
}

void touchUpWaldoSet( SliderZone s, Touch t )
{
	boolean changingResolution = true;
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
	TextureZone viewport;
	if ( changingWidth )
	{
		viewport = new TextureZone( "Viewport", oldX, oldY, newVal, oldHeight );
	}
	else
	{
		viewport = new TextureZone( "Viewport", oldX, oldY, oldWidth, newVal );
	}

	SMT.add( viewport );
	SMT.addChild( "Viewport", waldo );
}

void changeImageZone( boolean changingResolution, int index )
{
	ImageZone waldo = (ImageZone)SMT.get( "Viewport" ).getChild( 0 );
	SMT.removeChild( "Viewport", waldo );

	if ( changingResolution )
	{
		waldo = new ImageZone( "Waldo", waldo_images[curWaldoSet][index] );
		curWaldoRes = index;
	}
	else
	{
		// HARDCODED SELECTION from set not ideal; find way to update slider from here or obtain slider val
		waldo = new ImageZone( "Waldo", waldo_images[index][curWaldoRes] );
        curWaldoSet = index;
	}
	SMT.addChild( "Viewport", waldo );
}


// @TODO
// 	-investigate why viewport disappears when changed by sliders -- print values
//      -see if smoother resolution transitions are possible

