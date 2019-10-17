Bacteria[] allBacteria = new Bacteria[100]; // Array holding all bacteria instances
int frameElapsed = 0; // The frame elapsed, that is added per frame
int generationLength = 100; // The frames in one generation
float[] goalPoint; // The point the bacteria is trying to get to

 void setup()   
 {   
	// Style settings
	noStroke();
	textAlign(CENTER, CENTER);
 	size(500, 500);
	// Fill array with bacteria instances
	newGeneration();
	// Set the goal point
	goalPoint = new float[]{width/2, height/2};
 }   

 void draw()   
 {    
	background(200);
	// Checks if the generation is over, and if it is, then start a new generation
	if(frameElapsed > generationLength) {
		newGeneration();
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

 float calculateDistance(Bacteria obj) { // Calculates the distance between the object position and the goal point
	float distance;
	float xDistance = obj.position.x - goalPoint[0]; // Find the horizontal difference
	float yDistance = obj.position.y - goalPoint[1];
	distance = (float)(Math.sqrt(pow(xDistance, 2) + pow(yDistance, 2)));
	return distance;
 }

 class Bacteria    
 {     
 	Vector position; // A vector containing the position of the bacteria
	Vector[] path;
	int myColor;
	Bacteria() {
		// Randomize bacteria position
		float x = (float)(Math.random() * width);
		float y = (float)(Math.random() * height);
		position = new Vector(x, y);
		// Randomize bacteria color
		myColor = color((float)(Math.random() * 255), (float)(Math.random() * 255), (float)(Math.random() * 255));
	} 
	void show() {
		fill(myColor);
		ellipse(position.x, position.y, 10, 10);
		// Debug text
		textSize(10);
		fill(30);
		text(calculateDistance(this), position.x, position.y - 10);
	}
	void move() {
		position.x += (float)(Math.random() * 10 - 5);
		position.y += (float)(Math.random() * 10 - 5);
	}
	void generatePath() { // Generates an array of length equal to generation length that hold the path points
		path = new Vector[generationLength]; // Create a new array of generation length
		for(int i = 0; i < path.length; i++) {
			path
		} 
	}
 }    

 class Vector { // A object that contains 2 dimensional coordinates
	float x;
	float y;
	Vector(float argX, float argY) {
		x = argX;
		y = argY;
	}
 }