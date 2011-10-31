var touches	=	{}

function doubleTapped(e){
	e.preventDefault();
	window.location	=	window.location + "?close";
}

function resetScroll(){
	document.body.scrollTop	=	0;
}

function onTouchEnd(e){
	if(!touches.t1)
		touches.t1	=	(new Date()).getTime();

	else{
		touches.t2	=	(new Date()).getTime();
		if(touches.t2 - touches.t1 <= 300)
				doubleTapped(e);
		else	touches.t1	=	touches.t2;
	}
}

function onLoaded(){
	document.addEventListener("touchend", onTouchEnd, false);
}