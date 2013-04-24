/*
  **********************************************************
  ** Description: XSLT transform script
  **
  ** (c) Jiri Tyr 2007
  **********************************************************
*/


//  platformMoz:  http://www.mozilla.org/projects/xslt/js-interface.html
//  platformIE6:  http://www.perfectxml.com/articles/xml/XSLTInMSXML.asp

var platformMoz = (document.implementation && document.implementation.createDocument);
var platformIE6 = (!platformMoz && document.getElementById && window.ActiveXObject);
var noXSLT      = (!platformMoz && !platformIE6);

var msxmlVersion = '3.0';

var urlXML;
var urlXSL;
var docXML;
var docXSL;
var target;
var cache;
var done;
var processor;

var paramNames = new Array();
var paramValues = new Array();

if (platformIE6) {
	// TODO... find out version of MSXML installed
	cache = new ActiveXObject('Msxml2.XSLTemplate.' + msxmlVersion);
}

function Initialize(target, xml, xsl) {
	if (noXSLT) {
		FatalError();
		return;
	}

	SetTarget(target);
	SetInput(xml);
	SetStylesheet(xsl);
}

function SetTarget(id) {
	target = document.getElementById(id);
}

function SetInput(url) {
	urlXML = url;
}

function SetStylesheet(url) {
	urlXSL = url;
}

function SetDone(id) {
	done = id;
}

function SetParam(name, value) {
	var found = false;

	for (var i=0; i<paramNames.length; i++) {
		if (paramNames[i] == name) {
			paramValues[i] = value;
			found = true;
		}
	}

	if (!found) {
		paramNames[paramNames.length] = name;
		paramValues[paramValues.length] = value;
	}
}

function FatalError() {
	alert("Sorry, this doesn't work in your browser");
}

function NoSuchParam(name) {
	alert("There is no " + name + " parameter");
}

function CreateDocument() {
	var doc = null;

	if (platformMoz) {
		doc = document.implementation.createDocument('', '', null);
	} else if (platformIE6) {
		doc = new ActiveXObject('Msxml2.FreeThreadedDOMDocument.' + msxmlVersion);
	}

	return doc;
}

function Transform(done_target) {
	if (noXSLT) {
		FatalError();
		return;
	}

	SetDone(done_target);

	docXML = CreateDocument();
	docXSL = CreateDocument();

	if (platformMoz) {
		docXML.addEventListener('load', DoLoadXSL, false);
		docXML.load(urlXML);
	} else if (platformIE6) {
		docXML.async = false;
		docXML.load(urlXML);

		docXSL.async = false;
		docXSL.load(urlXSL);

		DoTransform();
	}
}

function DoLoadXSL() {
	if (platformMoz) {
		docXSL.addEventListener('load', DoTransform, false);
		docXSL.load(urlXSL);
	}
}

function DoTransform() {
	if (platformMoz) {
		processor = new XSLTProcessor();
		processor.importStylesheet(docXSL);

		AddParams(processor);

		var fragment = processor.transformToFragment(docXML, document);

		/*
		while (target.hasChildNodes()) {
			target.removeChild(target.childNodes[0]);
		}

		target.appendChild(fragment);
		*/

		var serializer = new XMLSerializer();
		var str = serializer.serializeToString(fragment);

		target.innerHTML = ReplaceSpecialCharacters(serializer.serializeToString(fragment));
	} else if (platformIE6) {
		cache.stylesheet = docXSL;

		processor = cache.createProcessor();
		processor.input = docXML;

		AddParams(processor);

		processor.transform();

		target.innerHTML = ReplaceSpecialCharacters(processor.output);
	}

	getBrowserObject(done).innerHTML = '1';
}

function ReplaceAll(str, s, r) {
	var index = str.indexOf(s);

	while (index != -1) {
		str = str.replace(s, r);
		index = str.indexOf(s);
	}

	return str;
}

function ReplaceSpecialCharacters(str) {
	str = ReplaceAll(str, '&lt;', '<');
	str = ReplaceAll(str, '&gt;', '>');

	return str;
}

function AddParams(processor) {
	for (var i=0; i<paramNames.length; i++) {
		if (paramValues[i] != '') {
			AddParam(processor, paramNames[i], paramValues[i]);
		}
	}
}

function AddParam(processor, name, value) {
	if (platformMoz) {
		processor.setParameter(null, name, value);
	} else if (platformIE6) {
		processor.addParameter(name, value);
	}
}
