public class Handle extends Zone
{
  public Viewport viewport;
  public int startX;
  public int startY;

  public Handle( int width, int height, int x, int y, String name, Viewport viewport )
  {
    super( name, x, y, width, height );
    this.viewport = viewport;
  }
}

/**
 * RIGHT X HANDLE
**/

void touchRightXHandle( Handle handle )
{
  handle.startX = handle.getX();
  handle.drag( true, false );    // Drag along only the X axis

  int widthChange = handle.getX() - handle.startX;
  int viewportWidth = handle.viewport.getWidth();

  if ( ( viewportWidth + widthChange ) > 0 )  // Avoid negative width
  {
    handle.viewport.setData( handle.viewport.getX(), handle.viewport.getY(),
                             viewportWidth + widthChange, handle.viewport.getHeight() );

  }

}

void touchUpRightXHandle( Handle handle )
{
  logger.logEvent( "RightXHandle", "Touch Up", "Viewport width is now: " + handle.viewport.getWidth() +
                   " pixels. {{ Aspect Ratio = " + handle.viewport.getWidth() + "/" + handle.viewport.getHeight() + " }}" );
}

void drawRightXHandle( Handle handle )
{
  fill( 255 );
  rect( 0, 0, handle.width, handle.height, 10 );
}

/**
 * LEFT X HANDLE
**/

void touchLeftXHandle( Handle handle )
{
  handle.startX = handle.getX();
  handle.drag( true, false );    // Drag along only the X axis

  int widthChange = -1 * ( handle.getX() - handle.startX );
  int viewportWidth = handle.viewport.getWidth();

  if ( ( viewportWidth + widthChange ) > 0 )  // Avoid negative width
  {
    handle.viewport.setData( handle.viewport.getX() - widthChange, handle.viewport.getY(),
                             viewportWidth + widthChange, handle.viewport.getHeight() );

  }

}

void touchUpLeftXHandle( Handle handle )
{
  logger.logEvent( "LeftXHandle", "Touch Up", "Viewport width is now: " + handle.viewport.getWidth() +
                   " pixels. {{ Aspect Ratio = " + handle.viewport.getWidth() + "/" + handle.viewport.getHeight() + " }}" );
}

void drawLeftXHandle( Handle handle )
{
  fill( 255 );
  rect( 0, 0, handle.width, handle.height, 10 );
}

/**
 * TOP Y HANDLE
**/

void drawTopYHandle( Handle handle )
{
  fill( 255 );
  rect( 0, 0, handle.width, handle.height, 10 );
}

void touchTopYHandle( Handle handle )
{
  handle.startY = handle.getY();
  handle.drag( false, true );    // Drag along only the Y axis

  int heightChange = -1 * ( handle.getY() - handle.startY ),
      viewportHeight = handle.viewport.getHeight();

  if ( ( viewportHeight + heightChange ) > 0 ) // Avoid negative height
  {
    System.out.println( "Height change: " + heightChange );
    handle.viewport.setData( handle.viewport.getX(), handle.viewport.y - heightChange,
                             handle.viewport.getWidth(), viewportHeight + heightChange );

  }

}

void touchUpTopYHandle( Handle handle )
{
  logger.logEvent( "TopYHandle", "Touch Up", "Viewport height is now: " + handle.viewport.getHeight() + " pixels" +
                   " pixels. {{ Aspect Ratio = " + handle.viewport.getWidth() + "/" + handle.viewport.getHeight() + " }}" );
}

/**
 * BOTTOM Y HANDLE
**/

void drawBottomYHandle( Handle handle )
{
  fill( 255 );
  rect( 0, 0, handle.width, handle.height, 10 );
}

void touchBottomYHandle( Handle handle )
{
  handle.startY = handle.getY();
  handle.drag( false, true );    // Drag along only the Y axis

  int heightChange = handle.getY() - handle.startY;
  int viewportHeight = handle.viewport.getHeight();

  if ( ( viewportHeight + heightChange ) > 0 ) // Avoid negative height
  {
    handle.viewport.setData( handle.viewport.getX(), handle.viewport.getY(),
                             handle.viewport.getWidth(), viewportHeight + heightChange );

  }

}

void touchUpBottomYHandle( Handle handle )
{
  logger.logEvent( "TopYHandle", "Touch Up", "Viewport height is now: " + handle.viewport.getHeight() + " pixels" +
                   " pixels. {{ Aspect Ratio = " + handle.viewport.getWidth() + "/" + handle.viewport.getHeight() + " }}" );
}

/**
 *  RIGHT SIDE XY HANDLES
**/
void drawTopRightXYHandle( Handle handle )
{
  fill( 255 );
  rect( 0, 0, handle.width, handle.height, 10 );
}

void touchTopRightXYHandle( Handle handle )
{
  handle.startY = handle.getY();
  handle.startX = handle.getX();
  handle.drag( true, true );    // Drag along only the Y axis

  int heightChange   = -1 * ( handle.getY() - handle.startY ),
      widthChange    = handle.getX() - handle.startX,
      viewportHeight = handle.viewport.getHeight(),
      viewportWidth  = handle.viewport.getWidth();


  if ( ( viewportHeight + heightChange ) > 0 ) // Avoid negative height
  {
    handle.viewport.setData( handle.viewport.getX(), handle.viewport.getY() - heightChange,
                             handle.viewport.getWidth() + widthChange, viewportHeight + heightChange );

  }

}

void touchUpTopRightXYHandle( Handle handle )
{
  logger.logEvent( "TopRightXYHandle", "Touch Up", "Viewport height is now: " + handle.viewport.getHeight() + " pixels" +
                   " pixels. {{ Aspect Ratio = " + handle.viewport.getWidth() + "/" + handle.viewport.getHeight() + " }}" );
}

void drawBottomRightXYHandle( Handle handle )
{
  fill( 255 );
  rect( 0, 0, handle.width, handle.height, 10 );
}

void touchBottomRightXYHandle( Handle handle )
{
  handle.startY = handle.getY();
  handle.startX = handle.getX();
  handle.drag( true, true );    // Drag along only the Y axis

  int heightChange   = ( handle.getY() - handle.startY ),
      widthChange    = handle.getX() - handle.startX,
      viewportHeight = handle.viewport.getHeight(),
      viewportWidth  = handle.viewport.getWidth();


  if ( ( viewportHeight + heightChange ) > 0 ) // Avoid negative height
  {
    handle.viewport.setData( handle.viewport.getX(), handle.viewport.getY(),
                             handle.viewport.getWidth() + widthChange, viewportHeight + heightChange );

  }

}

void touchUpBottomRightXYHandle( Handle handle )
{
  logger.logEvent( "BottomRightXYHandle", "Touch Up", "Viewport height is now: " + handle.viewport.getHeight() + " pixels" +
                   " pixels. {{ Aspect Ratio = " + handle.viewport.getWidth() + "/" + handle.viewport.getHeight() + " }}" );
}

/**
 *  LEFT SIDE XY HANDLES
**/
void drawTopLeftXYHandle( Handle handle )
{
  fill( 255 );
  rect( 0, 0, handle.width, handle.height, 10 );
}

void touchTopLeftXYHandle( Handle handle )
{
  handle.startY = handle.getY();
  handle.startX = handle.getX();
  handle.drag( true, true );    // Drag along only the Y axis

  int heightChange   = -1 * ( handle.getY() - handle.startY ),
      widthChange    = -1 * ( handle.getX() - handle.startX ),
      viewportHeight = handle.viewport.getHeight(),
      viewportWidth  = handle.viewport.getWidth();


  if ( ( viewportHeight + heightChange ) > 0 ) // Avoid negative height
  {
    handle.viewport.setData( handle.viewport.getX() - widthChange, handle.viewport.getY() - heightChange,
                             handle.viewport.getWidth() + widthChange, viewportHeight + heightChange );

  }

}

void touchUpTopLeftXYHandle( Handle handle )
{
  logger.logEvent( "TopLeftXYHandle", "Touch Up", "Viewport height is now: " + handle.viewport.getHeight() + " pixels" +
                   " pixels. {{ Aspect Ratio = " + handle.viewport.getWidth() + "/" + handle.viewport.getHeight() + " }}" );
}

void drawBottomLeftXYHandle( Handle handle )
{
  fill( 255 );
  rect( 0, 0, handle.width, handle.height, 10 );
}

void touchBottomLeftXYHandle( Handle handle )
{
  handle.startY = handle.getY();
  handle.startX = handle.getX();
  handle.drag( true, true );    // Drag along only the Y axis

  int heightChange   = ( handle.getY() - handle.startY ),
      widthChange    = -1 * ( handle.getX() - handle.startX ),
      viewportHeight = handle.viewport.getHeight(),
      viewportWidth  = handle.viewport.getWidth();


  if ( ( viewportHeight + heightChange ) > 0 ) // Avoid negative height
  {
    handle.viewport.setData( handle.viewport.getX() - widthChange, handle.viewport.getY(),
                             handle.viewport.getWidth() + widthChange, viewportHeight + heightChange );

  }

}

void touchUpBottomLeftXYHandle( Handle handle )
{
  logger.logEvent( "BottomLeftXYHandle", "Touch Up", "Viewport height is now: " + handle.viewport.getHeight() + " pixels" +
                   " pixels. {{ Aspect Ratio = " + handle.viewport.getWidth() + "/" + handle.viewport.getHeight() + " }}" );
}
