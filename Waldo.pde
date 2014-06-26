void touchWaldo( Zone z )
{
    if ( canWaldoBeTouched )
    {
      z.rst( false, true, true );
    }
}

void touchDownWaldo( Zone z )
{
  canViewportBeTouched = false;
}

void touchUpWaldo( Zone z )
{
  if ( z.getNumTouches() == 0 )
  {
    canViewportBeTouched = true;
  }
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
