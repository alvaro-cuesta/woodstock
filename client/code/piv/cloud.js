
module.exports = function() {

	var cloud = this;
	var x = ( Math.random() * $('#c').innerWidth() );
	var y = ( Math.random() * $('#c').innerHeight() ) - 120;
	var radius = ( Math.random() * 25 ) + 15;
	var opacity = ( Math.random() * 0.5 ) + 0.1
	var grow = (Math.random() * 2) - 1;

	var r = Math.round(Math.random() * 255);
	var g = Math.round(Math.random() * 255);
	var b = Math.round(Math.random() * 255);
	var opacity = 0;
	var opacitySpeed = 0;

	cloud.opacitySpeed = function(newOpacitySpeed) {
		opacitySpeed = newOpacitySpeed
	}

	cloud.update = function() {
		//x += (Math.random() * 4) - 2;
		//y += (Math.random() * 4) - 2;
		radius += grow;

		opacity += opacity >= 1 ? 0 : opacitySpeed;

		if(grow == 0) grow = 0.01;
		if(radius < 1) grow = -grow;
		if(radius > 50) grow = -grow;
	}

	cloud.draw = function() {
		ctx.save();
		ctx.globalCompositeOperation = "darker";
		ctx.beginPath();
		ctx.fillStyle = "rgba("+r+", "+g+", "+b+", "+ opacity +")";
		ctx.arc(x,y,radius,0,2*Math.PI);
		ctx.fill();
		ctx.restore();
	}

}