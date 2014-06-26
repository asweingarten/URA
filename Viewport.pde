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
  public Handle handleRightX;
  public Handle handleLeftX;

  public Handle handleTopY;
  public Handle handleBottomY;

  public Handle handleTopRightXY;
  public Handle handleBottomRightXY;

  public Handle handleTopLeftXY;
  public Handle handleBottomLeftXY;

  Viewport( int id, int x, int y, int width, int height )
  {
    super( "Viewport" , x, y, width, height, SMT.RENDERER );
    handleRightX = null;
    handleLeftX = null;
    handleTopY = null;
    handleBottomY = null;
//    this.scaleBackBuffer = true;

  }

  public void addContent( Zone content )
  {
    SMT.addChild( getName(), content );
  }

  public void removeContent( Zone content )
  {
    SMT.removeChild( getName(), content );
  }

  public void exposeHandles()
  {

    int handleWidth = 100,
        handleHeight = handleWidth,
        handleOffset = 50;

    int xHandleWidth  = 100,
        xHandleHeight = this.getHeight(),
        yHandleWidth  = this.getWidth(),
        yHandleHeight = 100;

    // X Handles
    handleRightX = new Handle( handleWidth, handleHeight, ( this.getX() + this.getWidth() + handleOffset ),
                          this.getY() + this.getHeight()/2,  "RightXHandle", this );
    SMT.add( handleRightX );

    handleLeftX = new Handle( handleWidth, handleHeight, ( this.getX() - 100 - handleOffset ), this.getY() + this.getHeight()/2,
                              "LeftXHandle", this );
    SMT.add( handleLeftX );

    // Y Handles
    handleTopY = new Handle( handleWidth, handleHeight, ( this.getX() + this.getWidth()/2 ),
                          this.getY() - 150, "TopYHandle", this );
    SMT.add( handleTopY );

    handleBottomY = new Handle( handleWidth, handleHeight, ( this.getX() + this.getWidth()/2 ),
                          this.getY() + this.getHeight() + handleOffset, "BottomYHandle", this );
    SMT.add( handleBottomY );

    // XY Handles
    // handleTopRightXY = new Handle( handleWidth, handleHeight, ( this.getX() + this.getWidth() + handleOffset ),
    //                                this.getY() - handleHeight - handleOffset, "TopRightXYHandle", this  );
    // SMT.add( handleTopRightXY );

    // handleBottomRightXY = new Handle( handleWidth, handleHeight, ( this.getX() + this.getWidth() + handleOffset ),
    //                                   this.getY() + this.getHeight() + handleOffset, "BottomRightXYHandle", this );
    // SMT.add( handleBottomRightXY );

    // handleTopLeftXY = new Handle( handleWidth, handleHeight, ( this.getX() - handleOffset - handleWidth ),
    //                                   this.getY() - handleHeight - handleOffset, "TopLeftXYHandle", this );
    // SMT.add( handleTopLeftXY );

    // handleBottomLeftXY = new Handle( handleWidth, handleHeight, ( this.getX() - handleOffset - handleWidth ),
    //                                   this.getY() + this.getHeight() + handleOffset, "BottomLeftXYHandle", this );
    // SMT.add( handleBottomLeftXY );

  }

  public void hideHandles()
  {
    if ( this.handleRightX != null )
      SMT.remove( this.handleRightX );

    if ( this.handleLeftX != null )
      SMT.remove( this.handleLeftX );

    if ( this.handleTopY != null )
      SMT.remove( this.handleTopY );

    if ( this.handleBottomY != null )
      SMT.remove( this.handleBottomY );

    if ( this.handleTopRightXY != null )
      SMT.remove( this.handleTopRightXY );

    if ( this.handleBottomRightXY != null )
      SMT.remove( this.handleBottomRightXY );

    if ( this.handleTopLeftXY != null )
      SMT.remove( this.handleTopLeftXY );

    if ( this.handleBottomLeftXY != null )
      SMT.remove( this.handleBottomLeftXY );

    this.handleRightX = null;
    this.handleLeftX = null;

    this.handleTopY = null;
    this.handleBottomY = null;

    this.handleTopRightXY = null;
    this.handleBottomRightXY = null;

    this.handleTopLeftXY = null;
    this.handleBottomLeftXY = null;

  }
}

void drawViewport( Zone z )
{
  fill(0);
  rect( 0, 0, z.getWidth(), z.getHeight() );
}

void touchViewport( Viewport vp )
{
    vp.rst();
    if ( vp.handleRightX == null && canViewportBeTouched )
       vp.drag();
}

void touchDownViewport( Viewport vp )
{

  if ( !canViewportBeTouched )
  {
    return;
  }
  //System.out.println("Waldo is NOT active");
  canWaldoBeTouched = false;


  if ( vp.handleRightX == null )
  {
    if ( vp.getNumTouches() == 2  )
    {

      vp.exposeHandles();
      logger.logEvent( "Viewport", "Two-finger Touch", "Exposing Handles" );
    }
    else
    {
      logger.logEvent( "Viewport", "One-finger Touch", "Dragging" );
    }
  }

}

void touchUpViewport( Viewport vp )
{

  if ( !canViewportBeTouched )
  {
    return;
  }
  //Jim's hack
  //vp.setDirect(true);
  //vp.setDirect(false);

  // System.out.println("Waldo IS active");
  canWaldoBeTouched = true;
  ImageZone waldo = (ImageZone)vp.getChildren()[0];

  int x = waldo.getX() - vp.getX(),
      y = waldo.getY() - vp.getY(),
      waldoWidth = waldo.getWidth(),
      waldoHeight = waldo.getHeight();

  System.out.println( "x: " + x + " y: " + y + " width: " + waldoWidth + " height: " + waldoHeight );

  changeImageZone( vp, x, y, waldoWidth, waldoHeight );

  waldo = (ImageZone)vp.getChildren()[0];
  waldo.setData( x, y, waldoWidth, waldoHeight );

  vp.hideHandles();

  logger.logEvent( "Viewport", "Touch Up", "Hide handles and update tiles" );
}


