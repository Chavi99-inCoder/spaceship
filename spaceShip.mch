/* spaceShip
 * Author: 
 *Folder : Doc/IIT/cw
 * Creation date: 2021-11-25
 */
MACHINE
    spaceShip

SETS
	RESPONSE = {MOVE_IS_SUCCESSFULLY, CANNOT_MOVE__OUT_OF_SPACE, POWER_IS_NOT_ENOUGH, DONT_MOVE_HIT_ASTEROID, CANNOT_MOVE_TO_ASTEROID, CANNOT_MOVE_TO_THE_SAME_POSITION, CANNOT_IMMEDIATELY_MOVE_AS_WARP_INTO_STARBASE};
	MOVEMENT = {MOVE_TO_UP, MOVE_TO_DOWN, MOVE_TO_FORWARD, MOVE_TO_BACKWARD, MOVE_AS_WARP};
	DOCKED_STATUS = {YES, NO};
	GAME_STATUS = {YOU_WON, YOU_LOST, CONTINUE}
 
CONSTANTS
	xSpace, ySpace, space, asteroids, gridSpace, homeBase, starBase, initMovePower, warpMovePower, hitAsteroidPowerLoss, initialPower
 
PROPERTIES
	// Grid space
	xSpace = 1..12 &
	ySpace = 1..7 &
	space = xSpace * ySpace &

// Empty Space
	gridSpace <: space &
	gridSpace /\ asteroids = {} &
	gridSpace \/ asteroids = space &
 
	// Asteroids
	asteroids <: space &
	asteroids = {3|->2, 3|->5, 5|->4, 6|->7, 7|->1, 7|->5, 7|->7, 8|->3, 10|->6, 11|->2, 12|->5} &
 
	// Homebase and Starbase
	homeBase : gridSpace & homeBase = 1|->1 &
	starBase : gridSpace & starBase = 6|->4&
 
	//movements properties
	initMovePower = 5 &
	warpMovePower = 20 &
	hitAsteroidPowerLoss = 10 &
	initialPower = 100
 
DEFINITIONS
	inSpace(xx, yy) == (xx |-> yy : space);
	isHitAsteroid(xx, yy) == (xx |-> yy : asteroids);
	hasEnoughPower(cp, rp) == (cp >= rp);
	docked == (xPosition |-> yPosition = starBase);
	gameOver == docked or (power < initMovePower);
 
/****** OPERATE ANIMATION FUNCTION ******/
	ANIMATION_FUNCTION== ({rr,cc,ii | rr:ySpace & cc:xSpace &          
       	(IF (cc = prj1(xSpace, ySpace)(starBase) & rr = prj2(xSpace, ySpace)(starBase))
           	THEN
               	// Starbase
  	             ii = 3
           	ELSE
               	IF (cc |-> (8 - rr) : asteroids)
               	THEN
                   	// Asteroid
                   	ii = 1
               	ELSE
                   	IF (cc = xPosition & rr = (8 - yPosition))
                   	THEN
                       	// Spaceship
                       	ii = 2
                   	ELSE
                       	// Empty space
                       	ii = 0
                   	END
               	END
           	END)});

	ANIMATION_IMG0 == "images/empty.gif";
	ANIMATION_IMG1 == "images/asteroid.gif";
	ANIMATION_IMG2 == "images/spaceship.gif";
	ANIMATION_IMG3 == "images/starbase.gif";

  
VARIABLES
	xPosition, yPosition, power, numOfCrashes, takenClearRoute, movements
 
INVARIANT
	xPosition : xSpace &
	yPosition : ySpace &
	xPosition |-> yPosition : gridSpace &
	power : NAT &
	numOfCrashes : NAT &
	takenClearRoute : seq(gridSpace) &
	movements : seq(MOVEMENT)
 
INITIALISATION
	power := initialPower ||
	numOfCrashes := 0 ||
	xPosition := prj1(xSpace, ySpace)(homeBase) ||
	yPosition := prj2(xSpace, ySpace)(homeBase) ||
	takenClearRoute := [homeBase] ||
	movements := []
 
OPERATIONS
	/****** Moves Up ******/
	response, movement <-- MoveUp =
	PRE
   	response : RESPONSE & movement : MOVEMENT & not(gameOver)
	THEN
   	IF
       	hasEnoughPower(power, initMovePower)
   	THEN
       	IF
           	inSpace(xPosition, yPosition + 1)
       	THEN
           	IF
               	not(isHitAsteroid(xPosition, yPosition + 1))
           	THEN
               	IF
                   	(power - initMovePower >= 0)
               	THEN
                   	yPosition := yPosition + 1 ||
                   	power := power - initMovePower ||
                   	takenClearRoute := takenClearRoute <- (xPosition |-> yPosition + 1) ||
                   	movements := movements <- MOVE_TO_UP ||
                   	response := MOVE_IS_SUCCESSFULLY ||
                   	movement := MOVE_TO_UP
               	ELSE
                 	  // Prevents power going below 0
                   	yPosition := yPosition + 1 ||
                   	power := 0 ||
                   	takenClearRoute := takenClearRoute <- (xPosition |-> yPosition + 1) ||
                   	movements := movements <- MOVE_TO_UP ||
                   	response := MOVE_IS_SUCCESSFULLY ||
                   	movement := MOVE_TO_UP
               	END
           	ELSE
               	IF
                   	(power - initMovePower - hitAsteroidPowerLoss >= 0)
               	THEN
                   	power := power - initMovePower - hitAsteroidPowerLoss ||
                   	numOfCrashes := numOfCrashes + 1 ||
 	                  response := DONT_MOVE_HIT_ASTEROID ||
                   	movement := MOVE_TO_UP
               	ELSE

                   	// Prevents power going below 0
                   	power := 0 ||
                   	numOfCrashes := numOfCrashes + 1 ||
                   	response := DONT_MOVE_HIT_ASTEROID ||
                   	movement := MOVE_TO_UP
               	END
           	END
       	ELSE
           	response := CANNOT_MOVE__OUT_OF_SPACE
       	END
   	ELSE
       	response := POWER_IS_NOT_ENOUGH
   	END
	END;
 
	/****** Moves Down ******/
	response, movement <-- MoveDown =
	PRE
   	response : RESPONSE & movement : MOVEMENT & not(gameOver)
	THEN
   	IF
       	hasEnoughPower(power, initMovePower)
   	THEN
       	IF
           	inSpace(xPosition, yPosition - 1)
       	THEN
           	IF
               	not(isHitAsteroid(xPosition, yPosition - 1))
           	THEN
               	IF
                   	(power - initMovePower >= 0)
               	THEN
                   	yPosition := yPosition - 1 ||
    	               power := power - initMovePower ||
                   	takenClearRoute := takenClearRoute <- (xPosition |-> yPosition - 1) ||
                   	movements := movements <- MOVE_TO_DOWN ||
                   	response := MOVE_IS_SUCCESSFULLY ||
                   	movement := MOVE_TO_DOWN
               	ELSE

                   	// Prevents power going below 0
                   	yPosition := yPosition - 1 ||
                   	power := 0 ||
                   	takenClearRoute := takenClearRoute <- (xPosition |-> yPosition - 1) ||
                   	movements := movements <- MOVE_TO_DOWN ||
                   	response := MOVE_IS_SUCCESSFULLY ||
                   	movement := MOVE_TO_DOWN
               	END
           	ELSE
               	IF
                   	(power - initMovePower - hitAsteroidPowerLoss >= 0)
               	THEN
                   	power := power - initMovePower - hitAsteroidPowerLoss ||
                       numOfCrashes := numOfCrashes + 1 ||
                   	response := DONT_MOVE_HIT_ASTEROID ||
                   	movement := MOVE_TO_DOWN
               	ELSE

                   	// Prevents power going below 0
            	       power := 0 ||
                   	numOfCrashes := numOfCrashes + 1 ||
                   	response := DONT_MOVE_HIT_ASTEROID ||
                   	movement := MOVE_TO_DOWN
               	END
           	END
       	ELSE
         	  response := CANNOT_MOVE__OUT_OF_SPACE
       	END
   	ELSE
       	response := POWER_IS_NOT_ENOUGH
   	END 
	END;
 
	/******Moves Forward ******/
	response, movement <-- MoveForward =
	PRE
   	response : RESPONSE & movement : MOVEMENT & not(gameOver)
	THEN
   	IF
       	hasEnoughPower(power, initMovePower)
   	THEN
       	IF
           	inSpace(xPosition + 1, yPosition)
       	THEN
           	IF
               	not(isHitAsteroid(xPosition + 1, yPosition))
           	THEN
               	IF
                   	(power - initMovePower >= 0)
               	THEN
                   	xPosition := xPosition + 1 ||
        	           power := power - initMovePower ||
                   	takenClearRoute := takenClearRoute <- (xPosition + 1 |-> yPosition) ||
                   	movements := movements <- MOVE_TO_FORWARD ||
                   	response := MOVE_IS_SUCCESSFULLY ||
                       movement := MOVE_TO_FORWARD
               	ELSE

                   	// Prevents power going below 0
                   	xPosition := xPosition + 1 ||
                   	power := 0 ||
                   	takenClearRoute := takenClearRoute <- (xPosition + 1 |-> yPosition) ||
                   	movements := movements <- MOVE_TO_FORWARD ||
                   	response := MOVE_IS_SUCCESSFULLY ||
                   	movement := MOVE_TO_FORWARD
               	END
       	    ELSE
               	IF
                   	(power - initMovePower - hitAsteroidPowerLoss >= 0)
               	THEN
                   	power := power - initMovePower - hitAsteroidPowerLoss ||
                   	numOfCrashes := numOfCrashes + 1 ||
                   	response := DONT_MOVE_HIT_ASTEROID ||
                   	movement := MOVE_TO_FORWARD
     	          ELSE

                   	// Prevents power going below 0
                   	power := 0 ||
                   	numOfCrashes := numOfCrashes + 1 ||
                   	response := DONT_MOVE_HIT_ASTEROID ||
                   	movement := MOVE_TO_FORWARD
               	END
           	END
       	ELSE
           	response := CANNOT_MOVE__OUT_OF_SPACE
       	END
   	ELSE
       	response := POWER_IS_NOT_ENOUGH
   	END 
	END;
 
	/****** Moves Backward ******/
	response, movement <-- MoveBackward =
	PRE
   	response : RESPONSE & movement : MOVEMENT & not(gameOver)
	THEN
   	IF
       	hasEnoughPower(power, initMovePower)
   	THEN
       	IF
           	inSpace(xPosition - 1, yPosition)
       	THEN
           	IF
               	not(isHitAsteroid(xPosition - 1, yPosition))
           	THEN
               	IF
                   	(power - initMovePower >= 0)
               	THEN
                   	xPosition := xPosition - 1 ||
                   	power := power - initMovePower ||
                   	takenClearRoute := takenClearRoute <- (xPosition - 1 |-> yPosition) ||
                   	movements := movements <- MOVE_TO_BACKWARD ||
                   	response := MOVE_IS_SUCCESSFULLY ||
                   	movement := MOVE_TO_BACKWARD
               	ELSE

                   	// Prevents power going below 0
                   	xPosition := xPosition - 1 ||
                   	power := 0 ||
                   	takenClearRoute := takenClearRoute <- (xPosition - 1 |-> yPosition) ||
                   	movements := movements <- MOVE_TO_BACKWARD ||
                   	response := MOVE_IS_SUCCESSFULLY ||
                   	movement := MOVE_TO_BACKWARD
               	END
           	ELSE
               	IF
                   	(power - initMovePower - hitAsteroidPowerLoss >= 0)
               	THEN
                   	power := power - initMovePower - hitAsteroidPowerLoss ||
                   	numOfCrashes := numOfCrashes + 1 ||
                   	response := DONT_MOVE_HIT_ASTEROID ||
                   	movement := MOVE_TO_BACKWARD
               	ELSE

                   	// Prevents power going below 0
                   	power := 0 ||
                   	numOfCrashes := numOfCrashes + 1 ||
                   	response := DONT_MOVE_HIT_ASTEROID ||
  	                 movement := MOVE_TO_BACKWARD
               	END
           	END
       	ELSE
           	response := CANNOT_MOVE__OUT_OF_SPACE
       	END
   	ELSE
       	response := POWER_IS_NOT_ENOUGH
   	END 
	END;
 
	/** Performs Warp Drive to the given position **/
	response, movement <-- EngageWarpDrive(newXPosition, newYPosition) =
	PRE
   	response : RESPONSE & movement : MOVEMENT &
   	newXPosition : NAT1 & newYPosition : NAT1 &
   	not(gameOver)
	THEN
   	IF
       	hasEnoughPower(power, warpMovePower)
   	THEN
       	IF
           	inSpace( newXPosition, newYPosition )
       	THEN
           	IF
               	(newXPosition = xPosition & newYPosition = yPosition)
           	THEN
               	response := CANNOT_MOVE_TO_THE_SAME_POSITION
           	ELSE
               	IF
                   	(size(takenClearRoute) = 1 & newXPosition|->newYPosition = starBase)
               	THEN
                   	response := CANNOT_IMMEDIATELY_MOVE_AS_WARP_INTO_STARBASE
               	ELSE
                   	IF
                       	not(isHitAsteroid(newXPosition, newYPosition))
                   	THEN
                       	IF
                           	(power - warpMovePower >= 0)
                       	THEN
                           	power := power - warpMovePower ||
                         	  xPosition := newXPosition ||
                           	yPosition := newYPosition ||
                           	takenClearRoute := takenClearRoute <- (newXPosition |-> newYPosition) ||
                           	movements := movements <- MOVE_AS_WARP ||
                               response := MOVE_IS_SUCCESSFULLY ||
                           	movement := MOVE_AS_WARP
                       	ELSE

                           	// Prevents power going below 0
                           	power := 0 ||
                           	xPosition := newXPosition ||
                           	yPosition := newYPosition ||
                   	        takenClearRoute := takenClearRoute <- (newXPosition |-> newYPosition) ||
                           	movements := movements <- MOVE_AS_WARP ||
                           	response := MOVE_IS_SUCCESSFULLY ||
                           	movement := MOVE_AS_WARP
 	                      END
                   	ELSE
                       	response := CANNOT_MOVE_TO_ASTEROID
                   	END
               	END
           	END
       	ELSE
           	response := CANNOT_MOVE__OUT_OF_SPACE
       	END
   	ELSE
       	response := POWER_IS_NOT_ENOUGH
   	END      
	END;
 
	/** Gives the current status of the space ship **/
	currentLocation, currentPower, asteroidCollisions <-- MissionStatus =
	BEGIN
	    currentLocation := xPosition |-> yPosition ||
   	currentPower := power ||
   	asteroidCollisions := numOfCrashes
	END;
 
	/** Gives the route that the space ship has travelled through **/
	route <-- MissionRoute =
	BEGIN
   	route := takenClearRoute
	END;
 
	/** Reports whether the space ship is docked at the star base **/
	dockedStatus <-- DockedAtStarbase =
	PRE
   	dockedStatus : DOCKED_STATUS
	THEN
   	IF
       	(docked)
   	THEN
       	dockedStatus := YES
   	ELSE
       	dockedStatus := NO
   	END
	END;
 
	/** Reports the game status **/
	status <-- GameStatus =
	PRE
   	status : GAME_STATUS
	THEN
   	IF
       	(docked)
   	THEN
       	status := YOU_WON
   	ELSE
       	IF
           	(power < initMovePower)
       	THEN
           	status := YOU_LOST
       	ELSE
           	status := CONTINUE
       	END
   	END
	END;
 
 
	/** Gives all movements taken by the space ship **/
	allMovements <-- takenMovements =
	BEGIN
   	allMovements := movements
	END;
 
	/** Resets the game, and starts again from the beginning **/
	resetGame =
	PRE
   	gameOver
	THEN
   	power := initialPower ||
   	numOfCrashes := 0 ||
   	xPosition := prj1(xSpace, ySpace)(homeBase) ||
   	yPosition := prj2(xSpace, ySpace)(homeBase) ||
   	takenClearRoute := [homeBase] ||
   	movements := []
	END
 
END

