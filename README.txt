Hello and Welcome to the Waldo Experiment. This is a visual search task where
participants are looking for Waldo in a classic Where's Waldo puzzle.



Breakdown of Source Code:

 - BackgroundZone.pde
 	A zone that covers the entire screen. It detects the "region definition
 	gesture".

 - Handles.pde
 	Zones that are placedaround the viewport to enable the user to change the
 	dimensions of the viewport. DEPRECATED

 - logger.pde
 	Logging utility written by Nancy

 - utilities.pde
 	Used by the logging utility, logger.pde

 - Viewport.pde
 	Viewport that contains the Where's Waldo image. The viewport is the
 	manifestation of the user's region on the screen.

 	Viewport Manipulation Options to be explored:
 		- Implicit handles at edges of viewport. These are always present and
 		 	adjust a dimension of the viewport when dragged.
 		- Auxilliary control zone that floats around bottom of viewport.
 		 	There are two options for what is in the control zone:
 		 		- Empty space for user to use modified pinch to zoom gesture
 		 		- Joystick for increasing dimension in given direction
 		 			How shrink an edge with this?
		- Direct pinch to zoom on viewport

 - Waldo.pde
 	Provides an ImageZone that contains a Where's Waldo puzzle.

 - Main.pde
 	Sets up the Processing Sketch



 TODO:
  - Try implementing auxilliary control zone
  	- Touch gestures in there get applied to viewport/content, but don't affect
  		the control zone itself



Things we want to do in the study:

	- Want to look at how people can walk up to the screen, "carve out" a space. Log initial size.
		- They should have some expectation of what they'll be doing with the space (i.e. what task are they performing)


