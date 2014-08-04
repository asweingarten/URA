import java.util.Map;

public class Tuple
{
  public int x;
  public int y;
  public Tuple(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
}

Map<Integer, Tuple> placementCoords = new HashMap<Integer, Tuple>();
Map<Integer, Zone> placementZones = new HashMap<Integer, Zone>();
Map<Integer, Tuple> viewCoords = new HashMap<Integer, Tuple>();
Map<Integer, Tuple> viewDims = new HashMap<Integer, Tuple>();



void drawBackgroundZone( Zone z )
{
  background( 0 );
}


void touchDownBackgroundZone(Zone z, Touch t )
{
  System.out.println("DOWN");

  // if Touch t is not too close to any other touch
  Touch[] touches = z.getTouches();
  for ( Touch touch : touches )
  {
    TouchPair pair = new TouchPair( t, touch );
    PVector toVec = pair.getToVec(),
            fromVec = pair.getFromVec();

    float distance = toVec.dist(fromVec);
    if ( distance < 400 && distance != 0 )
      return;
  }

  placementCoords.put( t.cursorID, new Tuple( t.x, t.y ) );
}

void touchBackgroundZone( Zone z )
{
  Touch[] touches = z.getTouches();
  for ( Touch touch : touches )
  {
    if ( placementCoords.containsKey( touch.cursorID ) )
    {
      if ( placementZones.containsKey( touch.cursorID ) )
      {
        Zone pZone = placementZones.get( touch.cursorID );
        SMT.remove( pZone );
      }
      spawnPlacementZone( touch );
    }
  }

}

void spawnPlacementZone( Touch t )
{
  Tuple placementCoordinates = placementCoords.get( t.cursorID );

  int placementX = placementCoordinates.x,
      placementY = placementCoordinates.y,
      placementWidth  = Math.abs( placementX - t.x ),
      placementHeight = Math.abs( placementY - t.y );

  viewDims.put( t.cursorID, new Tuple( placementWidth, placementHeight ) );

  int viewX = 0,
      viewY = 0;

  Zone placementZone = new Zone();

  if ( placementX > t.x && placementY > t.y )
  {
    // Dragged left and up
    placementZone = new Zone( "PlacementZone",
                       t.x,
                       t.y,
                       placementWidth,
                       placementHeight );
    // System.out.println( "Left and Up" );
    viewX = t.x;
    viewY = t.y;
  }
  else if ( placementX > t.x && placementY < t.y )
  {
    // Dragged left and down
    placementZone = new Zone( "PlacementZone",
                       t.x,
                       placementY,
                       placementWidth,
                       placementHeight );
    // System.out.println( "Left and Down" );
    viewX = t.x;
    viewY = placementY;
  }
  else if ( placementX < t.x && placementY < t.y )
  {
    // Dragged right and down
    placementZone = new Zone( "PlacementZone",
                       placementX,
                       placementY,
                       placementWidth,
                       placementHeight );
    // System.out.println( "Right and Down" );
    viewX = placementX;
    viewY = placementY;
  }
  else if ( placementX < t.x && placementY > t.y )
  {
    // Dragged right and up
    placementZone = new Zone( "PlacementZone",
                       placementX,
                       t.y,
                       placementWidth,
                       placementHeight );
    // System.out.println( "Right and Up" );
    viewX = placementX;
    viewY = t.y;
  }

  SMT.add( placementZone );
  placementZones.put( t.cursorID, placementZone );
  viewCoords.put( t.cursorID, new Tuple( viewX, viewY ) );
}

void drawPlacementZone( Zone z )
{
  if ( z.getWidth() < 400 || z.getHeight() < 400  )
  {
    // too small; show red
    fill( 255, 0, 0 );
  }
  else
  {
    // acceptable size; show green
    fill( 0, 255, 0 );
  }
  rect( 0, 0, z.getWidth(), z.getHeight() );
}

void touchUpBackgroundZone(Zone z, Touch t)
{
  if ( placementZones.containsKey( t.cursorID ) )
  {
    Tuple viewCoordinates = viewCoords.get( t.cursorID ),
          viewDimensions  = viewDims.get( t.cursorID );

    int viewX = viewCoordinates.x,
        viewY = viewCoordinates.y,
        viewWidth  = viewDimensions.x,
        viewHeight = viewDimensions.y;

    Zone placementZone = placementZones.get( t.cursorID );
    SMT.remove( placementZone );

    if ( viewWidth >= 400 && viewHeight >= 400 )
    {
      Viewport vp = new Viewport( nextViewPortID, viewX, viewY, viewWidth, viewHeight );
      nextViewPortID++;
      SMT.add( vp );

      PImage waldoSourceImage = waldo_images[curWaldoSet].get(),
             waldoImageClone = waldo_images[curWaldoSet].get();
      ImageZone waldoImageZone;

      if ( viewHeight < viewWidth )
      {
        // Viewport is wider than tall (widescreen)
        int waldoHeight = (int)Math.round((float)viewHeight*0.8),
            waldoYMargin = (int)Math.round((float)viewHeight*0.1),
            waldoXMargin;

        waldoImageClone.resize( 0, waldoHeight );
        waldoXMargin = (int)Math.round( ((float)viewWidth - waldoImageClone.width ) /2 );
        waldoImageZone = new ImageZone( "Waldo", waldoSourceImage, waldoXMargin, waldoYMargin, waldoImageClone.width, waldoImageClone.height );
      }
      else
      {
        // Viewport is taller than wide (like a vertical smartphone)
        int waldoWidth = (int)Math.round((float)viewWidth*0.8),
            waldoXMargin = (int)Math.round((float)viewWidth*0.1),
            waldoYMargin;

        waldoImageClone.resize( waldoWidth, 0 );

        waldoYMargin = (int)Math.round( ((float)viewHeight - waldoImageClone.height) / 2 );
        waldoImageZone = new ImageZone( "Waldo", waldoSourceImage, waldoXMargin, waldoYMargin, waldoImageClone.width, waldoImageClone.height );
      }

      Dimension viewDim  = vp.getScreenSize(),
                waldoDim = waldoImageZone.getScreenSize();

      waldoImageZone.refreshResolution();
      vp.addContent( waldoImageZone );

      logger.logEvent( "New View : " + vp.getName(),
                       "View: " +
                          "(X,Y) : (" +
                            vp.getX() + "," +
                            vp.getY() + ") "  +
                          "(W,H,AR) : (" +
                            viewDim.getWidth() + "," +
                            viewDim.getHeight() + "," +
                            (float)viewDim.getWidth()/(float)viewDim.getHeight(),
                        "Waldo: " +
                           "(X,Y) : (" +
                              waldoImageZone.getX() + "," +
                              waldoImageZone.getY() + ") " +
                           "(W,H,AR) : (" +
                              waldoDim.getWidth() + "," +
                              waldoDim.getHeight() + "," +
                              (float)waldoDim.getWidth()/(float)waldoDim.getHeight()
                        );

    }

  }
}
