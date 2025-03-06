'use strict';

const fs = require('fs');
const ical = require('node-ical');

var now = new Date();
var from = new Date();
var to = new Date();


from.setDate(now.getDate()-now.getDay()+1);
from.setHours(8);
from.setMinutes(0);
from.setSeconds(0);
from.setMilliseconds(0);

to.setDate(from.getDate()+11);
to.setHours(18);
to.setMinutes(0);
to.setSeconds(0);
to.setMilliseconds(0);

console.log("Filter from: " + from);
console.log("Filter to: " + to);

/*
// JSON data structure

{"events":[
        { "summary":"Lab open", "start_time":"Wed Jul 22 2020 09:00:00 GMT+0000 (Coordinated Universal Time)", "end_time":"Wed Jul 22 2020 13:00:00 GMT+0000 (Coordinated Universal Time)" },
        { "summary":"Lab open", "start_time":"Thu Jul 23 2020 09:00:00 GMT+0000 (Coordinated Universal Time)", "end_time":"Thu Jul 23 2020 10:00:00 GMT+0000 (Coordinated Universal Time)" },
        { "summary":"Lab open", "start_time":"Fri Jul 24 2020 10:00:00 GMT+0000 (Coordinated Universal Time)", "end_time":"Fri Jul 24 2020 16:00:00 GMT+0000 (Coordinated Universal Time)" }
    ]
}
*/


;(async () => {
    // you can also use the async lib to download and parse iCal from the web
    const webEvents = await ical.async.fromURL('https://outlook.office365.com/owa/calendar/a5dfb81a0adf4fa3a73dab13a881ae82@itu.dk/1f01bbd4c34c48378e85484905fe044711491492904918944522/calendar.ics');

	var jsonOutput = '{"events":['; 
	var isFirst = true;

    for (const event of Object.values(webEvents)) {
    	if (event.type == 'VEVENT'){

	    	if (event.start >= from && event.start < to){
	    		if (!isFirst){
	    			jsonOutput += ',';
	    		}
	    		jsonOutput += '{"summary":"'+event.summary+'","start_time":"'+event.start+'","end_time":"'+event.end+'"}';
	    		isFirst = false;
	    		
	    		console.log('Summary: ' + event.summary);
	    		console.log('Start: ' + event.start);
	    		console.log('End: ' + event.end);
	    	}
	    }
	}
	jsonOutput += ']}';
	console.log(jsonOutput);

	// write JSON string to a file
	fs.writeFile('/var/www/html/test/JSON/test1.json', jsonOutput, (err) => {
	    if (err) {
	        throw err;
	    }
	    console.log("JSON data is saved.");
	});


})().catch(console.error.bind());


