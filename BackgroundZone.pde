Touch windowOrigin = null;
boolean drawingRectangle = false,
        canPlaceNewViewport = false;;
int placementX,
    placementY,
    placementCursorID,
    viewX = 0,
    viewY = 0,
    viewWidth = 0,
    viewHeight = 0;



void drawBackgroundZone( Zone z )
{
  background( 35, 35, 125 );
}


void touchDownBackgroundZone(Zone z, Touch t )
{
  System.out.println("DOWN");

  if ( !drawingRectangle )
  {
    drawingRectangle = true;
    placementX = t.x;
    placementY = t.y;
    placementCursorID = t.cursorID;
    System.out.println( "drawing Rectangle TRUE" );
  }

  if (windowOrigin == null)
  {
    // windowOrigin = new Touch( t.sessionID, t.cursorID, t.x, t.y);
    windowOrigin.x = t.x;
    windowOrigin.y = t.y;

    System.out.println("TouchDown: " + t.sessionID + "  X:" + t.x + "  Y: " + t.y + " --  Origin: " + windowOrigin.sessionID + " X:" + windowOrigin.x + "  Y: " + windowOrigin.y );
  }
}

void touchBackgroundZone( Zone z )
{
  Touch[] touches = z.getTouches();
  Touch t = null;
  for ( Touch touch :  touches )
  {
    if ( touch.cursorID == placementCursorID )
    {
      t = touch;
    }
  }
  if ( t != null )
  {

    SMT.remove( "PlacementZone" );
    if ( SMT.get( "PlacementZone" ) == null )
    {
      spawnPlacementZone( t );
    }

  }

}

void spawnPlacementZone( Touch t )
{
  System.out.println( "touchy: " + t.x + " " + t.y );
  int placementWidth  = Math.abs( placementX - t.x ),
      placementHeight = Math.abs( placementY - t.y );

  viewWidth    = placementWidth;
  viewHeight = placementHeight;

  if ( placementX > t.x && placementY > t.y )
  {
    // Dragged left and up
    SMT.add( new Zone( "PlacementZone",
                       t.x,
                       t.y,
                       placementWidth,
                       placementHeight )
            );
    System.out.println( "Left and Up" );
    viewX = t.x;
    viewY = t.y;
  }
  else if ( placementX > t.x && placementY < t.y )
  {
    // Dragged left and down
    SMT.add( new Zone( "PlacementZone",
                       t.x,
                       placementY,
                       placementWidth,
                       placementHeight )
            );
    System.out.println( "Left and Down" );
    viewX = t.x;
    viewY = placementY;
  }
  else if ( placementX < t.x && placementY < t.y )
  {
    // Dragged right and down
    SMT.add( new Zone( "PlacementZone",
                       placementX,
                       placementY,
                       placementWidth,
                       placementHeight )
            );
    System.out.println( "Right and Down" );
    viewX = placementX;
    viewY = placementY;
  }
  else if ( placementX < t.x && placementY > t.y )
  {
    // Dragged right and up
    SMT.add( new Zone( "PlacementZone",
                       placementX,
                       t.y,
                       placementWidth,
                       placementHeight )
            );
    System.out.println( "Right and Up" );
    viewX = placementX;
    viewY = t.y;
  }
}

void drawPlacementZone( Zone z )
{
  if ( z.getWidth() < 400 || z.getHeight() < 400  )
  {
    // too small; show red
    fill( 255, 0, 0 );
    canPlaceNewViewport = false;
  }
  else
  {
    // acceptable size; show green
    fill( 0, 255, 0 );
    canPlaceNewViewport = true;
  }
  rect( 0, 0, z.getWidth(), z.getHeight() );
}

void touchUpBackgroundZone(Zone z, Touch t)
{
  System.out.println( "Touch Up on BZ" );
  drawingRectangle = false;
  SMT.remove( "PlacementZone" );

  if ( canPlaceNewViewport )
  {
    Viewport view = new Viewport( 1, viewX, viewY, viewWidth, viewHeight );
    SMT.add( view );
  }

  // logger.logEvent( "Background Zone", "touchDown", "" );
  System.out.println("TouchUp: " + t.sessionID + "  X:" + t.x + "  Y: " + t.y + " --  Origin: " + windowOrigin.sessionID + " X:" + windowOrigin.x + "  Y: " + windowOrigin.y );

  if (windowOrigin != null && windowOrigin.sessionID == t.sessionID )
  {
    System.out.println("MATCH");
    int windowWidth = windowOrigin.x - t.x,
        windowHeight = windowOrigin.y - t.y,
        windowX = 0,
        windowY = 0;

    if ( windowWidth > 0 && windowHeight > 0 )
    {
      // Dragged left and up
      windowX = t.x;
      windowY = t.y;
      System.out.println( "Left and Up" );
    }
    else if ( windowWidth > 0 && windowHeight < 0 )
    {
      // Dragged left and down
      windowX = t.x;
      windowY = windowOrigin.y;

      windowHeight *= -1;
      System.out.println( "Left and Down" );
    }
    else if ( windowWidth < 0 && windowHeight < 0 )
    {
      // Dragged right and down
      windowX = windowOrigin.x;
      windowY = windowOrigin.y;

      windowHeight *= -1;
      windowWidth *= -1;
      System.out.println( "Right and Down" );

    }
    else if ( windowWidth < 0 && windowHeight > 0 )
    {
      // Dragged right and up
      windowX = windowOrigin.x;
      windowY = t.y;

      windowWidth *= -1;
      System.out.println( "Right and Up" );
    }

    System.out.println("windowHeight: " + windowHeight + " windowWidth: " + windowWidth );
      // Maximum of 5 viewports
      //if ( viewports.size() >= 5 ) return;

      //      // Spawns viewport at touch point

    if ( windowWidth > 400 && windowHeight > 400)
    {

      Viewport view = new Viewport( nextViewPortID, windowX, windowY, windowWidth, windowHeight );
      nextViewPortID += 1;
      viewports.add( view );

      ImageZone waldo = new ImageZone( "Waldo", waldo_images[curWaldoSet], 100, 50 );
      //waldo.getZoneImage().resize( (int)(windowWidth * .9), (int)(windowHeight *.9) );
      SMT.add( view );

      view.addContent( waldo );
//      SMT.addChild( view, waldo );
   }
      windowOrigin = null;
  }
}
