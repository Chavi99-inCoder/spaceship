# spaceship


This coursework requires you to develop a B specification of a very simple version of the old Spaceship & Asteroids arcade game, using the B tools Atelier B & ProB.
Figure 1. gives the layout of the regions of space (a rectangular grid shape), the Spaceship is represented by the blue triangle, its starting position is its home base (1, 1).
The aim is to move the Spaceship from its home base through space using the various movement operations to get to the Starbase (6,4), avoiding the Asteroids.


Notes
 Space is made up of regions (squares of the grid) 12 wide by 7 high.
 The regions of space are populated by 11 asteroids, each in one region of space, & located
as shown in Figure 1 (imagin).
 The Spaceship occupies only one square at a time & can only be in an "empty space square", except when “docked” at the Starbase in its square (6,4).
For example, the Spaceship can be in region (5, 3), but not (8, 3) as it is occupied by an asteroid.
 The Spaceship is initially in its homebase, i.e. the bottom left square (1, 1).
 The spaceship can make a normal move, i.e. from one region of space (grid square) to an
adjacent one, in one of four directions: Up, Down, Forward (right) & Reverse (left).
 It uses up 5 units of power when it makes a normal move.
 The spaceship can engage its warp-drive & "jumps" to any region of space, except one occupied by an asteroid. It must not travel outside known space, i.e. outside the grid.
 It uses up 20 units of power when it engages its warp-drive, no matter how many regions it moves.
 If the spaceship crashes into one of the asteroids it loses 10 units of power.
 If it has less than the required amount of power to do either a normal move or a warp-drive
jump it can not do that type of move.

 
 The state of the game is one of the following:
 the spaceship docks at the Starbase, in which case the game has been Won.
 the spaceship is not docked at the Starbase & can not move because it has run out of power, in which case the game is Lost.
 otherwise the game is not over.
2 Develop a B Specification of the Regions of Space, Spaceship & Asteroids
Your B specification, i.e. collection of 1 or more B machines, should include the following elements.
2.1 Sets and Constants
Any sets and constants that are required to define the data and state of the spaceship, space, asteroids and their properties.
(Hints: Represent space and the asteroids as relations. What is the relationship between space, "empty space" & the asteroids locations?)
2.2 System State
The state variables required to represent space, asteroids and the spaceship. Including the state invariant and initialisation.
You can assume that the spaceship starts at its homebase, has no power, has not had any collisions and it has only visited the regions of space its homebase is located in.
2.3 New Game
To start or re-start the game use the NewGame( power ) operation. This should reset the spaceship to the initial state, except that it sets its power level to the value of the power parameter.
2.4 Spaceship Movements in Space
Note that all movement operations must report the outcome of an attempted movement. That is, either it was successful, failed due to space boundary issues, failed due to an asteroid, or failed for some other reason.
2.4.1 Normal Spaceship Movements
The following operations are the basic movements that all move the spaceship one region (square) in the appropriate direction in space and uses up 5 units of the spaceship's power:
 MoveUp
 MoveDown
 MoveForward
 MoveBackward (i.e. reverse)
Note that If the move results in the spaceship hitting an asteroid the spaceship remains in its current location, but its power is reduced by 10 units.
If any attempted movement cannot be performed because of the boundary of space or insufficient power then an error is reported.


2.4.2 Warp-drive Spaceship Movement
The movement operation:
 EngageWarpDrive( newposition )
where the player enters the newposition parameter, the region of space (i.e. grid co-ordinates) that the spaceship should warp jump to. Engaging the warp-drive uses up 20 units of the spaceship's power.
If the warp-drive cannot be used because the destination region input is either not within the known regions of space or is occupied by an asteroid or if there is insufficient power to use the warp-drive then an appropriate error message should be reported.
2.5 Spaceship's Mission Status
An enquiry operation MissionStatus that reports the current status of the spaceship:
 its current location,
 its current power reserves,
 how many asteroid collisions it has had.
2.6 Spaceship's Mission Route
An enquiry operation RegionsVisited that reports the regions of space that the spaceship has travelled through.
2.7 Spaceship is Docked at Starbase
An enquiry operation DockedAtStarbase that reports whether the Spaceship is “docked” at the Starbase, i.e. its current location is the Starbase.
2.7 Game Status
An enquiry operation GameStatus that reports:
 "Game WON" if the game is over & has been won;
 "Game LOST" if over & has been lost; and
 "Game Not Over" if its not over.
2.8 General Requirements
The B specification should use the appropriate features to define the data and operations in your B machine.
The specification must be syntactically and type correct, as checked by using the Atelier B tool.
The specification must be animated by ProB. That is it must initialise correctly and all operations can be animated successfully and used to move the Spaceship around the regions of space, e.g. from the homebase to the Starbase using a combination of all of the movement operations, including the warp jump.
