import java.util.*;

// Simulation settings
int generationLength = 150; // The frames in one generation
Vector spawnPoint = new Vector(20, 250);
Vector goalPoint = new Vector(480, 250); // The point the bacteria is trying to get to
float mutationRate = 20; // The mutation rate as a percentage
int colonySize = 20; // The number of bacteria in a colony

// Simulation states
Bacteria[] allBacteria = new Bacteria[colonySize]; // Array holding all bacteria instances
List<Wall> allWalls = new ArrayList<Wall>(); // A list holding all the walls
int frameElapsed = 0; // The frame elapsed, that is added per frame
int generationsElapsed = 1; // The number of generations elapsed
boolean running = false; // If the simulation is running or not
boolean placeWalls = false; // True if the simulation is going to place walls
boolean eraseWalls = false;
boolean placeSpawn = false;
boolean placeGoal = false;

// UI Objects
Button playButton;
Button pauseButton;
Button resetButton;
Button increaseNumBacteria;
Button decreaseNumBacteria;
Button increaseMutationRate;
Button decreaseMutationRate;
Toggle addWalls;
Toggle removeWalls;
Toggle setGoal;
Toggle setSpawn;

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
	// Instance ui elements
	playButton = new Button(new Vector(width - 140, 140), new Vector(70, 30), color(131, 255, 89), "Play", color(50));
	pauseButton = new Button(new Vector(width - 60, 140), new Vector(70, 30), color(255, 84, 84), "Pause", color(50));
	resetButton = new Button(new Vector(width - 100, 180), new Vector(100, 30), color(50), "Reset", color(240));
	increaseNumBacteria = new Button(new Vector(width - 80, 250), new Vector(30, 30), color(50), "+", color(240));
	decreaseNumBacteria = new Button(new Vector(width - 120, 250), new Vector(30, 30), color(50), "-", color(240));
	increaseMutationRate = new Button(new Vector(width - 80, 320), new Vector(30, 30), color(50), "+", color(240));
	decreaseMutationRate = new Button(new Vector(width - 120, 320), new Vector(30, 30), color(50), "-", color(240));
	addWalls = new Toggle(new Vector(width - 140, 370), new Vector(70, 30), color(50), "+ Walls", color(240));
	removeWalls = new Toggle(new Vector(width - 60, 370), new Vector(70, 30), color(50), "- Walls", color(240));
	setGoal = new Toggle(new Vector(width - 140, 410), new Vector(70, 30), color(50), "Set Goal", color(240));
	setSpawn = new Toggle(new Vector(width - 60, 410), new Vector(70, 30), color(50), "Set Spawn", color(240));
}

void mousePressed() {
	mouseButtonClicked = true;
	if(addWalls.toggled) { // For placing objects that only require a single click
		placeWalls();
	}
	else if(removeWalls.toggled) {
		eraseWalls();
	}
	else if(setGoal.toggled) {
		placeGoal();
		setGoal.toggled = false;
	}
	else if(setSpawn.toggled) {
		placeSpawn();
		setSpawn.toggled = false;
	}
}

void mouseDragged() { // For placing objects when the mouse is dragging
	if(addWalls.toggled) {
		placeWalls();
	}
	else if(removeWalls.toggled) {
		eraseWalls();
	}
}

void draw() {
	// Redraws the background
	background(30);

	// Draws grid
	fill(50);
	for(int x = 10; x < width - 200; x += 10) {
		for(int y = 10; y < height; y += 10) {
			rect(x, y, 9, 9, 2);
		}
	}

	// Draws walls
	for(Wall i : allWalls) {
		i.show();
	}

	// Draws goal point
	fill(255, 0, 0);
	rect(goalPoint.x, goalPoint.y, 9, 9, 2);
	// Draws spawn point
	fill(255, 255, 0);
	rect(spawnPoint.x, spawnPoint.y, 9, 9, 2);

	// Draws ui panel
	rectMode(CENTER);
	fill(0);
	rect(width - 97, 253, 180, 450, 5); // Draw ui panel drop shadow right
	fill(240);
	rect(width - 100, 250, 180, 450, 5); // Draw ui panel right
	// Draws generation text counter
	textSize(20);
	fill(30);
	text("Generation " + generationsElapsed, width - 100, 70);
	// Draws generation visual counter
	fill(50);
	rectMode(CORNER);
	rect(width - 175, 100, 150, 10);
	fill(131, 255, 89);
	rect(width - 175, 100, 150 * ((float)(frameElapsed)/generationLength), 10);
	rectMode(CENTER);
	// Calls all ui elements
	if(playButton.update()) {
		running = true;
	}
	if(pauseButton.update()) {
		running = false;
	}
	if(resetButton.update()) {
		newSet();
	}
	if(increaseNumBacteria.update()) {
		colonySize += 5;
	}
	else if(decreaseNumBacteria.update()) {
		if(colonySize != 5) { // Prevents it from going to zero
			colonySize -= 5;
		}
	}
	if(increaseMutationRate.update()) {
		if(mutationRate != 100) {
			mutationRate += 5; // Prevents mutation rate from exceeding 100
		}
	}
	else if(decreaseMutationRate.update()) {
		if(mutationRate != 0) {
			mutationRate -= 5;
		}
	}
	if(addWalls.update()) {
		if(addWalls.toggled) {
			removeWalls.toggled = false;
			setGoal.toggled = false;
			setSpawn.toggled = false;
		}
	}
	else if(removeWalls.update()) {
		if(removeWalls.toggled) {
			addWalls.toggled = false;
			setGoal.toggled = false;
			setSpawn.toggled = false;
		}
	}
	else if(setGoal.update()) {
		if(setGoal.toggled) {
			addWalls.toggled = false;
			removeWalls.toggled = false;
			setSpawn.toggled = false;
		}
	}
	else if(setSpawn.update()) {
		if(setSpawn.toggled) {
			addWalls.toggled = false;
			removeWalls.toggled = false;
			setGoal.toggled = false;
		}
	}
	playButton.show();
	pauseButton.show();
	resetButton.show();
	fill(30);
	text("# of Bacteria: " + colonySize, width - 100, 220);
	increaseNumBacteria.show();
	decreaseNumBacteria.show();
	fill(30);
	text("Mutation Rate: " + (int)mutationRate + "%", width - 100, 290);
	increaseMutationRate.show();
	decreaseMutationRate.show();
	addWalls.show();
	removeWalls.show();
	setGoal.show();
	setSpawn.show();
	mouseButtonClicked = false;

	// Checks if the generation is over, and if it is, then start a new mutated generation
	if(frameElapsed == generationLength) {
		newMutatedGeneration();
	}
	// Calls all bacteria once
	for(Bacteria i : allBacteria) {
		i.show();
		if(running) { // Only update bacteria if the simulation is running
			i.move();
		}
	}
	// Draws an indicator if there is a winner
	if(generationsElapsed > 0) {
		float x = allBacteria[0].position.x;
		float y = allBacteria[0].position.y;
		fill(255, 250, 97); // Draws crown
		triangle(x - 20, y - 50, x - 20, y - 15, x, y - 15);
		triangle(x - 20, y - 15, x, y - 50, x + 20, y - 15);
		triangle(x, y - 15, x + 20, y - 50, x + 20, y - 15);
	}
	if(running) { // Only iterate the framerate if the simulation is running
		frameElapsed++;
	}
}  

void newSet() { // Creates a new generation of bacteria
	allBacteria = new Bacteria[colonySize]; // Creates a new array
	for(int i = 0; i < allBacteria.length; i++) {
		allBacteria[i] = new Bacteria();
	}
	frameElapsed = 0;
	generationsElapsed = 1;
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
	allBacteria = new Bacteria[colonySize]; // Creates a new array
	allBacteria[0] = new Bacteria(); // Creates a new first bacteria
	allBacteria[0].copy(winner, true); // Set first bacteria to winner
	allBacteria[0].reset(); // Reset the winner
	for(int i = 1; i < allBacteria.length; i++) { // Create a new generation based on winner
		allBacteria[i] = new Bacteria(); // Creates a new bacteria
		allBacteria[i].copy(allBacteria[0], false); // Clones winner
		allBacteria[i].mutate(); // Mutates clone
	}
	frameElapsed = 0;
	generationsElapsed++; // Iterate the number of generations
}

void placeWalls() { // Add walls at mouse position
	int x = (int)(mouseX - mouseX % 10);
	int y = (int)(mouseY - mouseY % 10);
	if(x > 0 && x < 500 && y > 0 && y < 500) { // Only if the point is within the grid
		boolean occupied = false;
		for(Wall i : allWalls) { // Searches if the spot is already filled
			if(x == i.x && y == i.y) {
				occupied = true;
				break;
			}
		}
		if(occupied == false) {
			allWalls.add(new Wall(x, y)); // Adds a wall to a closest point to the mouse that is the multiple of ten
		}
	}
}

void eraseWalls() {
	int x = (int)(mouseX - mouseX % 10);
	int y = (int)(mouseY - mouseY % 10);
	if(x > 0 && x < 500 && y > 0 && y < 500) {
		for(Wall i : allWalls) { // Searches if there is an occupied spot and deletes it
			if(x == i.x && y == i.y) {
				allWalls.remove(i);
				break;
			}
		}
	}
}

void placeGoal() {
	int x = (int)(mouseX - mouseX % 10);
	int y = (int)(mouseY - mouseY % 10);
	if(x > 0 && x < 500 && y > 0 && y < 500) {
		goalPoint = new Vector(x, y);
	}
}

void placeSpawn() {
	int x = (int)(mouseX - mouseX % 10);
	int y = (int)(mouseY - mouseY % 10);
	if(x > 0 && x < 500 && y > 0 && y < 500) {
		spawnPoint = new Vector(x, y);
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
		origin = new Vector(spawnPoint.x, spawnPoint.y);
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
		if(get((int)(position.x + path[pathIndex].x), (int)(position.y)) != color(255)) {
			position.x += path[pathIndex].x;
			// Caps position to grid space
			if(position.x > 490) {
				position.x = 490;
			}
			else if(position.x < 10) {
				position.x = 10;
			}
		}
		if(get((int)(position.x), (int)(position.y + path[pathIndex].y)) != color(255)) {
			position.y += path[pathIndex].y;
			if(position.y > 490) {
				position.y = 490;
			}
			else if(position.y < 10) {
				position.y = 10;
			}
		}
		//position.add(path[pathIndex]);
	}
	void generatePath() { // Generates the path for the bacteria
		path = new Vector[generationLength]; // Create a new array of generation length
		for(int i = 0; i < path.length; i++) { // Fills path with random displacements
			path[i] = new Vector(((int)(Math.random() * 3) - 1) * 10, ((int)(Math.random() * 3) - 1) * 10);
		}
	}
	void mutate() { // Mutates the bacteria path
		for(int i = 0; i < path.length; i++) {
			if(Math.random() * 100 < mutationRate) { // Decides whether to mutate the current displacement
				path[i] = new Vector(((int)(Math.random() * 3) - 1) * 10, ((int)(Math.random() * 3) - 1) * 10);
			}
		}
	}
	void copy(Bacteria target, boolean copyColor) { // Copys the values of another bacteria
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

class Wall { // A wall that prevents bacteria from going through
	float x;
	float y;
	Wall(float argX, float argY) {
		x = argX;
		y = argY;
	}
	void show() {
		fill(255);
		rect(x, y, 9, 9, 2);
	}
}

class Button { // An object that allows for interactable buttons
	Vector position;
	Vector dimensions;
	int myColor;
	int textColor;
	String message; // The text that is displayed on the button
	boolean pressed = false;
	boolean hovered = false;
	Button(Vector argPosition, Vector argDimensions, int argMyColor, String argMessage) { // The constructer if no text color is specified
		position = argPosition;
		dimensions = argDimensions;
		myColor = argMyColor;
		message = argMessage;
		textColor = color(30);
	}
	Button(Vector argPosition, Vector argDimensions, int argMyColor, String argMessage, int argTextColor) { // If the text color is specified
		position = argPosition;
		dimensions = argDimensions;
		myColor = argMyColor;
		message = argMessage;
		textColor = argTextColor;
	}
	boolean update() { // Receives inputs and returns a boolean if button was pressed during frame
		if(mouseX <= position.x + dimensions.x/2.0 && mouseX >= position.x - dimensions.x/2.0 && mouseY <= position.y + dimensions.y/2.0 && mouseY >= position.y - dimensions.y/2.0) {
			hovered = true;
			if(mouseButtonClicked) {
				pressed = true; // Updates button state if mouse press is in the button
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
		fill(textColor);
		textSize(14);
		text(message, position.x, position.y);
	}
}

class Toggle extends Button { // A button that visually stays pressed when pressed
	boolean toggled = false;
	Toggle(Vector argPosition, Vector argDimensions, int argMyColor, String argMessage) {
		super(argPosition, argDimensions, argMyColor, argMessage);
	}
	Toggle(Vector argPosition, Vector argDimensions, int argMyColor, String argMessage, int argTextColor) {
		super(argPosition, argDimensions, argMyColor, argMessage, argTextColor);
	}
	boolean update() { // Receives inputs and returns a boolean if button was pressed during frame
		if(mouseX <= position.x + dimensions.x/2.0 && mouseX >= position.x - dimensions.x/2.0 && mouseY <= position.y + dimensions.y/2.0 && mouseY >= position.y - dimensions.y/2.0) {
			hovered = true;
			if(mouseButtonClicked) {
				toggled = !toggled; // Updates button state if mouse press is in the button
				return true;
			}
			else {
				return false;
			}
		}
		else {
			hovered = false;
			return false;
		}
	}
	void show() { // Draws the button
		if(toggled) {
			fill(red(myColor) - 80, green(myColor) - 80, blue(myColor) - 80);
		}
		else if(hovered) {
			fill(red(myColor) - 50, green(myColor) - 50, blue(myColor) - 50);
		}
		else {
			fill(myColor);
		}
		rect(position.x, position.y, dimensions.x, dimensions.y, 5);
		fill(textColor);
		textSize(14);
		text(message, position.x, position.y);
	}
}