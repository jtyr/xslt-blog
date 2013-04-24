/*
  **********************************************************
  ** Description: Special functions for jscalendar
  **
  ** (c) Jiri Tyr 2007
  **********************************************************
*/


var calendar_langs = ['af', 'al', 'bg', 'br', 'ca', 'cs', 'da', 'de', 'du', 'el', 'en', 'es', 'fi', 'fr', 'he', 'hr', 'it', 'jp', 'ko', 'lt', 'pl', 'pt', 'ro', 'ru', 'si', 'sk', 'sp', 'sv', 'tr', 'zh'];
var calendar_langs_utf8 = ['cs', 'he', 'hr', 'ko', 'lt', 'pl', 'ru'];
var cal_lang = 'en';
var Dates = new Object();

// get default value of calendar language from Setting.xsl file
ajax('./xsl/Setting.xsl', getCalLang);

function loadCalLang() {
	var e = document.createElement('script');
	e.src = './design/js/jscalendar-1.0/lang/calendar-'+cal_lang+'.js';
	e.type = 'text/javascript';

	document.getElementsByTagName('head')[0].appendChild(e);
}

function ourDateStatusFunc(date, y, m, d) {
	if (dateIsSpecial(y, m+1, d)) {
	        return 'special';
	} else {
	        return false;
	}
}

function dateChanged(calendar) {
	if (calendar.dateClicked) {
		var y = calendar.date.getFullYear();
		var m = calendar.date.getMonth();
		var d = calendar.date.getDate();
		//alert(y + '/' + m + '/' + d);
		window.location = 'index.html?date='+sprintf('%d%02d%02d', y, m+1, d);
	}
}

function insertDate(year, month, day) {
	if (! Dates[year]) {
		Dates[year] = new Object();
	}

	if (! Dates[year][month]) {
		Dates[year][month] = new Object();
	}

	if (! Dates[year][month][day]) {
		Dates[year][month][day] = 1;
	}
}

function dateIsSpecial(year, month, day) {
	if (! Dates[sprintf('%04d', Math.round(year))]) {
		return false;
	} else if (! Dates[sprintf('%04d', Math.round(year))][sprintf('%02d', Math.round(month))]) {
		return false;
	} else if (! Dates[sprintf('%04d', Math.round(year))][sprintf('%02d', Math.round(month))][sprintf('%02d', Math.round(day))]) {
		return false;
	} else {
		return true;
	}
}

function getCalLang() {
	var params = xmlDoc.getElementsByTagName('param');
	for (var i=0; i<params.length; i++) {
		var tag = params.item(i);
		if (tag.getAttribute('name') == 'calendar_lang') {
			var val = tag.getAttribute('select');
			cat_lang = val.substring(1, val.length-1);
			//alert('xxx: ' + cat_lang);
		}
	}
}
