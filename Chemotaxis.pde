// Simulation states
Bacteria[] allBacteria = new Bacteria[100]; // Array holding all bacteria instances
int frameElapsed = 0; // The frame elapsed, that is added per frame
int generationsElapsed = 0; // The number of generations elapsed

// Simulation settings
int generationLength = 100; // The frames in one generation
Vector goalPoint; // The point the bacteria is trying to get to
float mutationRate = 20; // The mutation rate as a percentage

// UI Objects
Button resetButton;

// UI States
boolean mouseButtonClicked = false;

void setup() {   
	// Style settings
	noStroke();
	textAlign(CENTER, CENTER);
 	size(700, 500);
	rectMode(CENTER);
	// Fill array with bacteria instances
	newSet();
	// Set the goal point
	goalPoint = new Vector(width/2, height/2);
	// Instance ui elements
	resetButton = new Button(new Vector(width - 100, 400), new Vector(100, 30), color(240), "Reset");
}

void mouseClicked() {
	mouseButtonClicked = true;
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

	// Draws ui on sidebar
	// Draws generation text counter
	textSize(20);
	fill(240);
	text("Generation " + generationsElapsed, width - 100, 70);
	// Draws generation visual counter
	rectMode(CORNER);
	fill(131, 255, 89);
	rect(width - 175, 100, 150 * ((float)(frameElapsed)/generationLength), 10);
	rectMode(CENTER);
	// Draws winner window
	float x = width - 100; // Local variables to make things easier
	float y = 200;
	fill(50);
	rect(x, y, 70, 70, 5); // Draws panel
	if(generationsElapsed > 0) { // Only draws winner after the first generation
		fill(allBacteria[0].myColor);
		ellipse(x, y, 10, 10); // Draws bacteria
		fill(255, 250, 97); // Draws crown
		triangle(x - 10, y - 25, x - 10, y - 7.5, x, y - 7.5);
		triangle(x - 10, y - 7.5, x, y - 25, x + 10, y - 7.5);
		triangle(x, y - 7.5, x + 10, y - 25, x + 10, y - 7.5);
		fill(240);
		textSize(14);
	}
	text("Winner", x, y + 18);

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
	// Calls all ui elements
	if(resetButton.update()) {
		newSet();
	}
	resetButton.show();
	// Draws an indicator if there is a winner
	if(generationsElapsed > 0) {
		x = allBacteria[0].position.x;
		y = allBacteria[0].position.y;
		fill(255, 250, 97); // Draws crown
		triangle(x - 20, y - 50, x - 20, y - 15, x, y - 15);
		triangle(x - 20, y - 15, x, y - 50, x + 20, y - 15);
		triangle(x, y - 15, x + 20, y - 50, x + 20, y - 15);
	}
	frameElapsed++; // Iterate the framerate
	mouseButtonClicked = false;
}  

void newSet() { // Creates a new generation of bacteria
	for(int i = 0; i < allBacteria.length; i++) {
		allBacteria[i] = new Bacteria();
	}
	frameElapsed = 0;
	generationsElapsed = 0;
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
		myColor = color((float)(Math.random() * 154) + 100, (float)(Math.random() * 154) + 100, (float)(Math.random() * 154) + 100);
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

class Vector { // An object that contains 2 dimensional coordinates
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

class Button { // An object that allows for interactable buttons
	Vector position;
	Vector dimensions;
	int myColor;
	String message; // The text that is displayed on the button
	boolean pressed = false;
	boolean hovered = false;
	Button(Vector argPosition, Vector argDimensions, int argMyColor, String argMessage) {
		position = argPosition;
		dimensions = argDimensions;
		myColor = argMyColor;
		message = argMessage;
	}
	boolean update() { // Receives inputs and returns a boolean if button was pressed during frame
		if(mouseX <= position.x + dimensions.x/2.0 && mouseX >= position.x - dimensions.x/2.0 && mouseY <= position.y + dimensions.y/2.0 && mouseY >= position.y - dimensions.y/2.0) {
			hovered = true;
			if(mouseButtonClicked) {
				pressed = true; // Updates button state if mouse press is in the button
				System.out.println("PRESSED");
				return true;
			}
			else {
				pressed = false;
				return false;
			}
		}
		else {
			pressed = false;
			hovered = false;
			return false;
		}
	}
	void show() { // Draws the button
		if(pressed) {
			fill(red(myColor) - 80, green(myColor) - 80, blue(myColor) - 80);
		}
		else if(hovered) {
			fill(red(myColor) - 50, green(myColor) - 50, blue(myColor) - 50);
		}
		else {
			fill(myColor);
		}
		rect(position.x, position.y, dimensions.x, dimensions.y, 5);
		fill(30);
		text(message, position.x, position.y);
	}
}