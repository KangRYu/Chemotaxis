Bacteria[] allBacteria = new Bacteria[100]; // Array holding all bacteria instances
int frameElapsed = 0;
int lengthOfGeneration = 100;

 void setup()   
 {   
	// Style settings
	noStroke();
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
	}

	void update() {
		x += (float)(Math.random() * 10 - 5);
		y += (float)(Math.random() * 10 - 5);
	}
 }    