/*
  **********************************************************
  ** Description: Global functions
  **
  ** (c) Jiri Tyr 2007
  **********************************************************
*/


function isSupported() {
	if (existsCookie('continue') || (BrowserDetect.browser == 'Firefox' && BrowserDetect.version >= 1) || BrowserDetect.browser == 'Mozilla' || (BrowserDetect.browser == 'Explorer' && BrowserDetect.version >= 6) || (BrowserDetect.browser == 'Netscape' && BrowserDetect.version >= 8) || (BrowserDetect.browser == 'Opera' && BrowserDetect.version >= 9.5)) {
		showContent();
	} else {
		getBrowserObject('Xslt').style.display = 'block';
	}
}


function showContent() {
	if (existsCookie('exist_cookie')) {
		removeCookie('exist_cookie');
	}

	getBrowserObject('Xslt').style.display = 'none';
	getBrowserObject('Wait').style.display = 'block';
	getData();
}


function runScripts(id) {
	var d = getBrowserObject(id);
	if (d.getElementsByTagName) {
		var scripts = d.getElementsByTagName('script');

        	for (var i=0; i<scripts.length; i++) {
			// execute the script
			if (scripts[i].innerHTML.length > 0) {
				//alert(scripts[i].innerHTML);
        			eval(scripts[i].innerHTML);
			}
                }
	}
}


function getBrowserObject(id) {
	var obj;

	if (document.all) {
		obj = document.all[id];
	} else if (document.getElementById) {
		obj = document.getElementById(id);
	}

	if (! obj) {
		alert('ID "' + id + '" not found.');
	}

	return(obj);
}


function externalLinks(d) {
	if (!d) {
		d = document;
	}

	if (d.getElementsByTagName) {
		var anchors = d.getElementsByTagName('a');

        	for (var i=0; i<anchors.length; i++) {
        		var anchor = anchors[i];

            		if (anchor.getAttribute('href') && anchor.getAttribute('rel') == 'external') {
            			anchor.target = '_blank';
			}
                }
	}
}


// sprintf() function - overtaken [from http://alexei.417.ro/blog/sprintf_for_javascript.html]
function str_repeat(i, m) { for (var o = []; m > 0; o[--m] = i); return(o.join('')); }
function sprintf () {
	var i = 0, a, f = arguments[i++], o = [], m, p, c, x;
	while (f) {
		     if (m = /^[^\x25]+/.exec(f)) o.push(m[0]);
		else if (m = /^\x25{2}/.exec(f)) o.push('%');
		else if (m = /^\x25(?:(\d+)\$)?(\+)?(0|'[^$])?(-)?(\d+)?(?:\.(\d+))?([b-fosuxX])/.exec(f)) {
			if (((a = arguments[m[1] || i++]) == null) || (a == undefined)) throw("Too few arguments.");
			if (/[^s]/.test(m[7]) && (typeof(a) != 'number'))
				throw("Expecting number but found " + typeof(a));

			switch (m[7]) {
				case 'b': a = a.toString(2); break;
	    			case 'c': a = String.fromCharCode(a); break;
    				case 'd': a = parseInt(a); break;
    				case 'e': a = m[6] ? a.toExponential(m[6]) : a.toExponential(); break;
	    			case 'f': a = m[6] ? parseFloat(a).toFixed(m[6]) : parseFloat(a); break;
			        case 'o': a = a.toString(8); break;
			        case 's': a = ((a = String(a)) && m[6] ? a.substring(0, m[6]) : a); break;
			        case 'u': a = Math.abs(a); break;
			        case 'x': a = a.toString(16); break;
			        case 'X': a = a.toString(16).toUpperCase(); break;
		        }

		        a = (/[def]/.test(m[7]) && m[2] && a > 0 ? '+' + a : a);
			c = m[3] ? m[3] == '0' ? '0' : m[3].charAt(1) : ' ';
			x = m[5] - String(a).length;
			p = m[5] ? str_repeat(c, x) : '';
			o.push(m[4] ? a + p : p + a);
		} else throw ("Huh ?!");

	        f = f.substring(m[0].length);
	}

	return o.join('');
}