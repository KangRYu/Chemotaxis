Bacteria[] allBacteria = new Bacteria[100]; // Array holding all bacteria instances
int frameElapsed = 0;
int lengthOfGeneration = 100;

 void setup()   
 {   
	// Style settings
	noStroke();
	textAlign(CENTER, CENTER);
 	size(500, 500);
	// Fill array with bacteria instances
	newGeneration();
 }   

 void draw()   
 {    
	background(200);
	if(frameElapsed > lengthOfGeneration) {
		newGeneration();
		frameElapsed = 0;
	}
	// Calls all bacteria once
	for(Bacteria i : allBacteria) {
		i.show();
		i.update();
	}
	frameElapsed++;
 }  

 void newGeneration() {
	for(int i = 0; i < allBacteria.length; i++) {
		allBacteria[i] = new Bacteria();
	}
 }

 float calculateDistance(Bacteria obj, float x, float y) { // Calculates the distance between an object and a point
	float distance;
	float xDistance = obj.x - x;
	float yDistance = obj.y - y;
	distance = (float)(Math.sqrt(pow(xDistance, 2) + pow(yDistance, 2)));
	return distance;
 }

 class Bacteria    
 {     
 	float x;
	float y;
	int myColor;

	Bacteria() {
		// Randomize bacteria position
		x = (float)(Math.random() * width);
		y = (float)(Math.random() * height);
		// Randomize bacteria color
		myColor = color((float)(Math.random() * 255), (float)(Math.random() * 255), (float)(Math.random() * 255));
	} 

	void show() {
		fill(myColor);
		ellipse(x, y, 10, 10);
		// Debug text
		textSize(10);
		fill(30);
		text(calculateDistance(this, 0, 0), x, y - 10);
	}

	void update() {
		x += (float)(Math.random() * 10 - 5);
		y += (float)(Math.random() * 10 - 5);
	}
 }    