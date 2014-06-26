boolean canWaldoBeTouched = true;
boolean canViewportBeTouched = true;


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
  Viewport( int id, int x, int y, int width, int height )
  {
    super( "Viewport" + id, x, y, width, height, SMT.RENDERER );
//    this.scaleBackBuffer = true;


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
  // vp.drag();
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


