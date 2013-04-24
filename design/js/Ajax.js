function ajax(url, user_func) {
	if (url.length > 0) {
		if (window.ActiveXObject) {
			httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
		} else {
			httpRequest = new XMLHttpRequest();
		}

		httpRequest.open("GET", url, true);
		httpRequest.onreadystatechange = function () { processRequest(user_func); };
		httpRequest.send(null);
	}
}


function processRequest(user_func) {
	if (httpRequest.readyState == 4) {
		if (httpRequest.status == 200) {
			if (httpRequest.responseText != "") {
				xmlDoc = initXml(httpRequest.responseText);

				// run the user function
				user_func(xmlDoc);
			} else {
				alert("The text of the response is empty!");
			}
		} else {
			alert("Page download error '" + httpRequest.status + "': " + httpRequest.statusText);
		}
	}
}


function initXml(xmlText) {
	var xmlDoc;

	if (document.implementation && document.implementation.createDocument) {
		// Mozilla
		var Parser = new DOMParser();
		xmlDoc = Parser.parseFromString(xmlText, "text/xml");
	} else if (window.ActiveXObject) {
		// IE
		xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc.loadXML(xmlText);
	} else {
		alert("Your browser can't handle this script");
		return;
	}

	return(xmlDoc);
}


function getXmlText(node) {
	var ret;

	if (node.xml) {
		ret = node.xml;
	} else if (XMLSerializer) {
		var XS = new XMLSerializer();
		ret = XS.serializeToString(node);
	}

	ret = ret.replace(/^<.[^>]+>/, "");
	ret = ret.replace(/<\/.[^>]+>$/, "");

	return(ret);
}
