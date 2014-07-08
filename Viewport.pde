boolean canWaldoBeTouched = true;
boolean canViewportBeTouched = true;

import java.awt.Dimension;

// Parent class of Viewport
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

public class Viewport extends NewTextureZone
{
  public float lastScaleX,
               lastScaleY;

  Viewport( int id, int x, int y, int width, int height )
  {
    super( "Viewport" + id, x, y, width, height, SMT.RENDERER );
    lastScaleX = 1;
    lastScaleY = 1;
  }

  //  Description:
  //    Gets the delta scaling amount from last time this has been called
  public float getInverseScale()
  {
    PMatrix3D global = getGlobalMatrix();
    //origin vector
    PVector o1 = new PVector( 0, 0);
    //x unit vector
    PVector x1 = new PVector( 1, 0);
    //y unit vector
    PVector y1 = new PVector( 0, 1);
    //y unit vector
    PVector z1 = new PVector( 0, 0, 1);
    //apply matrix
    PVector o2 = global.mult( o1, null);
    PVector x2 = global.mult( x1, null);
    PVector y2 = global.mult( y1, null);
    PVector z2 = global.mult( z1, null);
    //extract scaling factors
    float x_scale = o2.dist( x2);
    float y_scale = o2.dist( y2);
    float z_scale = o2.dist( z2);

    if ( lastScaleX == x_scale )
    {
      System.out.println("returning 0");
      return 0;
    }

    float tempScale = lastScaleX;
    lastScaleX = x_scale;
    return tempScale / x_scale;
  }

  //  Description:
  //    Adds a zone into the viewport as a child zone
  //  Input:
  //    Zone content: the zone to be added as a child
  public void addContent( Zone content )
  {
    SMT.addChild( getName(), content );
    this.translate( 0, 0, -1 );
    this.getChildren()[0].translate( 0, 0, 1 );
    SMT.get("BackgroundZone").translate(0,0,-1);
    System.out.println("Child added: " + this.getChildren()[0].getName() );
  }

  //  Description:
  //    Removes a zone from the viewport
  //  Input:
  //    Zone content: the child zone to be removed
  public void removeContent( Zone content )
  {
    SMT.removeChild( getName(), content );
  }

}

//  Description:
//    How the viewport is drawn
//  Input:
//    Zone z : the viewport zone
void drawViewport( Zone z )
{
  fill(0);
  rect( 0, 0, z.getWidth()*100, z.getHeight()*100 );
  // background(0);
}

//  Description:
//    What happens when the viewport is touched
//  Input:
//    Viewport vp : the viewport being touched
void touchViewport( Viewport vp )
{
  vp.rst( false, true, true );

  float inverseScale = vp.getInverseScale();

  if ( inverseScale != 0 )
  {
    ImageZone waldo = (ImageZone)vp.getChildren()[0];
    PImage img = waldo.getZoneImage().get();
    // img.resize( (int)Math.round(deltaScale*waldo.width), (int)Math.round(deltaScale*waldo.height) );
    waldo.scale(inverseScale, inverseScale);
    // waldo.width  = Math.round( deltaScale*waldo.getWidth() );
    // waldo.height = Math.round( deltaScale*waldo.getHeight() );
    // waldo.setZoneImage(img);
  }
  System.out.println( "scaleX: " + inverseScale + " | scaleY: " + inverseScale );

}

//  Description:
//    What happens when a viewport is first touched
//  Input:
//    Viewport vp : the viewport being touched
void touchDownViewport( Viewport vp )
{
  if ( !canViewportBeTouched )
  {
    return;
  }
  //System.out.println("Waldo is NOT active");
  canWaldoBeTouched = false;

}

void touchUpViewport( Viewport vp )
{
  vp.refreshResolution();

  if ( !canViewportBeTouched )
  {
    return;
  }

  // System.out.println("Waldo IS active");
  canWaldoBeTouched = true;

  vp.translate(0,0,-1);
  vp.getChildren()[0].translate(0,0,1);
  SMT.get("BackgroundZone").translate(0,0,-1);

  // Change the waldo image to avoid zone "freezing"
  // ImageZone waldo = (ImageZone)vp.getChildren()[0];

  // int x = waldo.getX() - vp.getX(),
  //     y = waldo.getY() - vp.getY(),
  //     waldoWidth = waldo.getWidth(),
  //     waldoHeight = waldo.getHeight();

  // System.out.println( "x: " + x + " y: " + y + " width: " + waldoWidth + " height: " + waldoHeight );

  // changeImageZone( vp, x, y, waldoWidth, waldoHeight );

  // waldo = (ImageZone)vp.getChildren()[0];
  // waldo.setData( x, y, waldoWidth, waldoHeight );

  logger.logEvent( "Viewport", "Touch Up", "Hide handles and update tiles" );
}


