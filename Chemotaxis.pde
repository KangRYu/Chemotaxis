// Simulation states
Bacteria[] allBacteria = new Bacteria[100]; // Array holding all bacteria instances
int frameElapsed = 0; // The frame elapsed, that is added per frame
int generationsElapsed = 0; // The number of generations elapsed

// Simulation settings
int generationLength = 100; // The frames in one generation
Vector goalPoint; // The point the bacteria is trying to get to
float mutationRate = 20; // The mutation rate as a percentage

 void setup() {   
	// Style settings
	noStroke();
	textAlign(CENTER, CENTER);
 	size(700, 500);
	rectMode(CENTER);
	// Fill array with bacteria instances
	newGeneration();
	// Set the goal point
	goalPoint = new Vector(width/2, height/2);
 }   

 void draw() {    
	background(30);

	// Draws grid
	fill(50);
	for(int x = 10; x < width - 200; x += 10) {
		for(int y = 10; y < height; y += 10) {
			rect(x, y, 9, 9, 2);
		}
	}

	// Draws goal point
	fill(255, 0, 0);
	rect(goalPoint.x, goalPoint.y, 9, 9, 2);

	// Draws side bars
	textSize(20);
	fill(240);
	text("Generation " + generationsElapsed, width - 100, 70);

	// Checks if the generation is over, and if it is, then start a new mutated generation
	if(frameElapsed == generationLength) {
		newMutatedGeneration();
		frameElapsed = 0;
		generationsElapsed++; // Iterate the number of generations
	}
	// Calls all bacteria once
	for(Bacteria i : allBacteria) {
		i.show();
		i.move();
	}
	// Draws an indicator if there is a winner
	if(generationsElapsed > 0) {
		Vector position = allBacteria[0].position;
		fill(230, 0, 0);
		triangle(position.x, position.y - 15, position.x - 15, position.y - 50, position.x + 15, position.y - 50);
	}
	frameElapsed++; // Iterate the framerate
 }  

 void newGeneration() { // Creates a new generation of bacteria
	for(int i = 0; i < allBacteria.length; i++) {
		allBacteria[i] = new Bacteria();
	}
 }

 void newMutatedGeneration() { // Creates a new generation based on the previous winners
 	// Stores a copy of the winner into the winner variable
	Bacteria winner = new Bacteria();
	winner.copy(allBacteria[0], true);
	for(Bacteria i : allBacteria) { // Goes through all bacteria, so that winner stores the closest bacteria to the goal
		if(calculateDistance(i) < calculateDistance(winner)) {
			winner.copy(i, true);
		}
	}
	System.out.println(calculateDistance(winner));
	allBacteria[0].copy(winner, true); // Set first bacteria to winner
	allBacteria[0].reset(); // Reset the winner
	for(int i = 1; i < allBacteria.length; i++) { // Create a new generation based on winner
		allBacteria[i].copy(allBacteria[0], false); // Clones winner
		allBacteria[i].mutate(); // Mutates clone
	}
 }

 float calculateDistance(Bacteria obj) { // Calculates the distance between the object position and the goal point
	float distance;
	float xDistance = obj.position.x - goalPoint.x; // Find the horizontal difference
	float yDistance = obj.position.y - goalPoint.y;
	distance = (float)(Math.sqrt(pow(xDistance, 2) + pow(yDistance, 2)));
	return distance;
 }

 class Bacteria {     
	Vector origin; // The starting point of the Bacteria
 	Vector position; // A vector containing the position of the bacteria
	Vector[] path; // An array containing the displacement of the bacteria in each frame
	int pathIndex = 0; // The current index of the path array
	int myColor;
	Bacteria() {
		// Starting position
		origin = new Vector(10, 10);
		position = new Vector(origin.x, origin.y);
		// Randomize bacteria color
		myColor = color((float)(Math.random() * 155) + 100, (float)(Math.random() * 155) + 100, (float)(Math.random() * 155) + 100);
		// Creates a path for the bacteria
		generatePath();
	} 
	void show() {
		fill(myColor);
		ellipse(position.x, position.y, 10, 10);
	}
	void move() {
		if(pathIndex < generationLength - 1) {
			pathIndex ++;
		}
		position.add(path[pathIndex]);
	}
	void generatePath() { // Generates the path for the bacteria
		path = new Vector[generationLength]; // Create a new array of generation length
		for(int i = 0; i < path.length; i++) { // Fills path with random displacements
			path[i] = new Vector((int)(Math.random() * 3 - 1) * 10, (int)(Math.random() * 3 - 1) * 10);
		}
	}
	void mutate() { // Mutates the bacteria path
		for(int i = 0; i < path.length; i++) {
			if(Math.random() * 100 < mutationRate) { // Decides whether to mutate the current displacement
				path[i] = new Vector((int)(Math.random() * 3 - 1) * 10, (int)(Math.random() * 3 - 1) * 10);
			}
		}
	}
	void copy(Bacteria target, boolean copyColor) { // Copys the values of another bacteria
		origin = new Vector(target.origin.x, target.origin.y);
		position = new Vector(target.position.x, target.position.y);
		pathIndex = target.pathIndex;
		for(int i = 0; i < path.length; i++) {
			path[i] = target.path[i];
		}
		if(copyColor) {
			myColor = target.myColor;
		}
	}
	void reset() { // Resets position and index of the bacteria
		pathIndex = 0;
		position = new Vector(origin.x, origin.y);
	}
 }    

 class Vector { // A object that contains 2 dimensional coordinates
	float x;
	float y;
	Vector(float argX, float argY) {
		x = argX;
		y = argY;
	}
	void add(Vector argVector) { // Adds vector with another
		x += argVector.x;
		y += argVector.y;
	}
 }