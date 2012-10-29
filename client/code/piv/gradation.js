
module.exports = function(canvas) {

	gradation = this;

	gradation.update = function() {

	}

	gradation.draw = function() {
		// Top
		/*
		var grd = canvas.ctx.createLinearGradient(0, 0, 0, 200);

		grd.addColorStop(0, "rgba(37, 40, 49, 1)");
		grd.addColorStop(0.5, "rgba(37, 40, 49, 0.4)");
		grd.addColorStop(1, "rgba(37, 40, 49, 0)");

		// Fill with gradient
		canvas.ctx.fillStyle = grd;
		canvas.ctx.fillRect(0, 0, canvas.width, 200);
		*/

		// Bottom
		var grd = canvas.ctx.createLinearGradient(0, 100, 0, 500);

		grd.addColorStop(0, "rgba(37, 40, 49, 0)");
		grd.addColorStop(0.5, "rgba(37, 40, 49, 0.8)");
		grd.addColorStop(1, "rgba(37, 40, 49, 1)");

		// Fill with gradient
		canvas.ctx.fillStyle = grd;
		canvas.ctx.fillRect(0, 0, canvas.width, 500);
	}

}