void touchWaldo( Zone z )
{
    if ( canWaldoBeTouched )
    {
      z.rst( false, true, true );
      z.getParent().translate(0,0,-1);
      z.translate(0,0,1);
      SMT.get("BackgroundZone").translate(0,0,-1);
    }
}

void touchDownWaldo( Zone z )
{
  canViewportBeTouched = false;
}

void touchUpWaldo( ImageZone waldo )
{
  // log here
  if ( waldo.getNumTouches() == 0 )
  {
    canViewportBeTouched = true;
  }


  Viewport vp = (Viewport)waldo.getParent();
  Dimension waldoDim = waldo.getScreenSize(),
            viewDim = vp.getScreenSize();
  logger.logEvent( "Touch Up View : " + vp.getName(),
                   "View: " +
                      "(X,Y) : (" +
                        vp.x + "," +
                        vp.y + ") "  +
                      "(W,H,AR) : (" +
                        viewDim.getWidth() + "," +
                        viewDim.getHeight() + "," +
                        (float)viewDim.getWidth()/(float)viewDim.getHeight(),
                    "Waldo: " +
                       "(X,Y) : (" +
                          waldo.x + "," +
                          waldo.y + ") " +
                       "(W,H,AR) : (" +
                          waldoDim.getWidth() + "," +
                          waldoDim.getHeight() + "," +
                          (float)waldoDim.getWidth()/(float)waldoDim.getHeight()
                    );
  waldo.refreshResolution();
}


void changeImageZone( Zone viewport, int x, int y, int waldoWidth, int waldoHeight )
{
  // int nextImageNum = ( curWaldoImageNum + 1 ) % DISTINCT_WALDO_IMAGES;
  ImageZone waldo = (ImageZone)viewport.getChild( 0 );
  SMT.removeChild( viewport, waldo );


  // PImage img = waldo.getZoneImage();

  waldo = (ImageZone)waldo.clone();
  System.out.println( "changed image" );

  PImage img = null;
  // curWaldoSet += 1;
  try
  {
   img = (PImage)waldo_images[curWaldoSet].clone();
  }
  catch( Exception e )
  {
    System.out.println( e );
  }

  waldo = new ImageZone( "Waldo", img, x, y, waldoWidth, waldoHeight );

  // curWaldoSet = nextImageNum;
  SMT.addChild( viewport, waldo );
}
