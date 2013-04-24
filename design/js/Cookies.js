/*
  **********************************************************
  ** Description: Functions for cookies
  **
  ** (c) Jiri Tyr 2007
  **********************************************************
*/


setCookie('exist_cookie', 'yes');


function setCookie(name, value, expires, path, domain, secure) {
	document.cookie= name + '=' + escape(value) +
    		((expires) ? '; expires=' + expires.toGMTString() : '') +
    		((path) ? '; path=' + path : '') +
    		((domain) ? '; domain=' + domain : '') +
    		((secure) ? '; secure' : '');
};


function getCookie(name) {
	var c = document.cookie.split('; ');
	var ret;

	for (var i=0; i<c.length; i++) {
		var p = c[i].split('=');

		if (p[0] == name) {
			ret = p[1];
			break;
		}
	}

	return ret;
};


function existsCookie(name) {
	var exists = false;
	var c = document.cookie.split('; ');

	for (var i=0; i<c.length; i++) {
		var p = c[i].split('=');

		if (p[0] == name) {
			exists = true;
			break;
		}
	}

	return exists;
};


function removeCookie(name, path, domain) {
	if (getCookie(name)) {
    		document.cookie = name + '=' + 
        		((path) ? '; path=' + path : '') +
        		((domain) ? '; domain=' + domain : '') +
        		'; expires=Thu, 01-Jan-70 00:00:01 GMT';
    }
};
