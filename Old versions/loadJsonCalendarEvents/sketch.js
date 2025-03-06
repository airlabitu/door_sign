let result;
function preload() {
  result = loadJSON('https://airlab2.itu.dk/test/JSON/test1.json');
}

function setup() {
  
  background(255);
  for (var i = 0; i < result.events.length; i++){
  	createP(result.events[i].summary);
  	createP(result.events[i].start_time);
  	createP(result.events[i].end_time);
  	createP("---");
  }
}