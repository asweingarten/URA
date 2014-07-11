import vialab.SMT.*;
import java.util.*;

/**
 *  Global Variables
**/

// int screenWidth = 1440; //= 1366;
// int screenHeight = 900; // = 768;
int screenWidth  = 1920*4;
int screenHeight = 1080*2;

final int TEXT_SIZE = 36; // pixels
final int DISTINCT_WALDO_IMAGES = 3;
final int STARTING_RESOLUTION_LEVEL = 5;
final int DEFAULT_VIEWPORT_WIDTH = screenWidth/4;
final int DEFAULT_VIEWPORT_HEIGHT = screenHeight/4;

Logger logger;

PImage[] waldo_images = new PImage[ DISTINCT_WALDO_IMAGES ];
ArrayList<Viewport> viewports = new ArrayList<Viewport>();

int curWaldoSet = 0;
int curWaldoRes = 1;
int nextViewPortID = 0;

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
    waldo_images[i] = loadImage( "Pix/" + (i+1) + ".jpg" );
  }

}

void setup()
{
  // Place the window in the top left corner,
  // and make sure that it's always on top
  // frame.setAlwaysOnTop(true);
  frame.setLocation(0,0);
  size( screenWidth, screenHeight, SMT.RENDERER );
  SMT.init(this, TouchSource.MULTIPLE);
  SMT.setTouchSourceBoundsScreen();
  SMT.setWarnUnimplemented( false );

  // Setup Logger
  String path = "logs/";
  String name = "test";
  logger = new Logger( path, name );

  // Set text-size (px)
  textSize( TEXT_SIZE );

  // Background zone detects touches that spawn new Viewports
  SMT.add( new Zone( "BackgroundZone", 0, 0, screenWidth, screenHeight ) );

  // Create first viewport
//  Viewport view0 = new Viewport( nextViewPortID, screenWidth/4, screenHeight/4, DEFAULT_VIEWPORT_WIDTH, DEFAULT_VIEWPORT_HEIGHT );

//  viewports.add( view0 );
  nextViewPortID += 1;

  // Add first viewport to SMT
//  SMT.add( view0 );

  // Create ImageZone for first Waldo image and add to init viewport
//  ImageZone waldo = new ImageZone( "Waldo", waldo_images[curWaldoSet], 100, 50 );
//  view0.addContent( waldo );
}

void draw()
{
  background( 79, 129, 189 );
}
