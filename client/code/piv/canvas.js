
module.exports = function($c) {
	var canvas = this;

	canvas.c = c[0]
        canvas.$c = $c
	canvas.ctx = c.getContext("2d");
	
	c.width = $(document).innerWidth();
	c.height = 500;

	canvas.width = c.width;
	canvas.height = c.height;
	canvas.background = "rgb(37, 40, 49)";

	canvas.y1 = 1;
	canvas.variation = 1;

	canvas.gridSize = 5;

	canvas.update = function() {
		canvas.y1 += 10;
		//canvas.variation = canvas.y1 > 100 || canvas.y1 < 1 ? -canvas.variation : canvas.variation;
	}

	canvas.draw = function() {
		// Clears the screen
		ctx = canvas.ctx;
		ctx.fillStyle = canvas.background;
		ctx.fillRect(0, 0, canvas.width, canvas.height);

		// Grid
		requiredLines = Math.ceil(c.width / canvas.gridSize);
		ctx.lineWidth = 0.25;

		for(i = 0; i < requiredLines; i++) {
			gridOpacity = i % 2 == 1? 0.5 : 0.1;
			ctx.strokeStyle = 'rgba(255, 255, 255, '+ gridOpacity +')';
			ctx.beginPath();
			ctx.moveTo(i * canvas.gridSize, 0);
			ctx.lineTo(i * canvas.gridSize, c.height);
			ctx.stroke();
		}
		
		requiredLines = Math.ceil(c.height / canvas.gridSize);

		for(i = 0; i < requiredLines; i++) {
			gridOpacity = i % 2 == 1? 0.5 : 0.1;
			ctx.strokeStyle = 'rgba(255, 255, 255, '+ gridOpacity +')';
			ctx.beginPath();
			ctx.moveTo(0, i * canvas.gridSize);
			ctx.lineTo(c.width, i * canvas.gridSize);
			ctx.stroke();
		}



	}
}