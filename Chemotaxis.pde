Bacteria[] allBacteria = new Bacteria[100]; // Array holding all bacteria instances
int frameElapsed = 0; // The frame elapsed, that is added per frame

// Simulation settings
int generationLength = 100; // The frames in one generation
Vector goalPoint; // The point the bacteria is trying to get to
float mutationRate = 50; // The mutation rate as a percentage

 void setup() {   
	// Style settings
	noStroke();
	textAlign(CENTER, CENTER);
 	size(500, 500);
	// Fill array with bacteria instances
	newGeneration();
	// Set the goal point
	goalPoint = new Vector(width/2, height/2);
 }   

 void draw() {    
	background(200);
	// Checks if the generation is over, and if it is, then start a new mutated generation
	if(frameElapsed == generationLength) {
		newMutatedGeneration();
		frameElapsed = 0;
	}
	// Calls all bacteria once
	for(Bacteria i : allBacteria) {
		i.show();
		i.move();
	}
	frameElapsed++; // Iterate the framerate
 }  

 void newGeneration() { // Creates a new generation of bacteria
	for(int i = 0; i < allBacteria.length; i++) {
		allBacteria[i] = new Bacteria();
	}
 }

 void newMutatedGeneration() { // Creates a new generation based on the previous winners
	Bacteria winner = allBacteria[0]; // A bacteria containing the sole winner
	for(Bacteria i : allBacteria) { // Goes through all bacteria, so that winner stores the closest bacteria to the goal
		if(calculateDistance(i) < calculateDistance(winner)) {
			winner = i;
		}
	}
	allBacteria[0] = winner; // Set first bacteria to winner
	allBacteria[0].reset(); // Reset the winner
	for(int i = 1; i < allBacteria.length; i++) { // Create a new generation based on winner
		allBacteria[i] = allBacteria[0]; // Clones winner
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
		// Randomize bacteria position
		float x = (float)(Math.random() * width);
		float y = (float)(Math.random() * height);
		origin = new Vector(x, y);
		position = origin;
		// Randomize bacteria color
		myColor = color((float)(Math.random() * 255), (float)(Math.random() * 255), (float)(Math.random() * 255));
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
			path[i] = new Vector((float)(Math.random() * 10 - 5), (float)(Math.random() * 10 - 5));
		}
	}
	void mutate() { // Mutates the bacteria path
		for(Vector displacement : path) {
			if(Math.random() * 100 < mutationRate) { // Decides whether to mutate the current displacement
				displacement = new Vector((float)(Math.random() * 10 - 5), (float)(Math.random() * 10 - 5));
			}
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