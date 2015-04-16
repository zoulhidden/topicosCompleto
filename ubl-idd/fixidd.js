var doc = WScript.CreateObject("MSXML2.DOMDocument" );
doc.async = false;
doc.load( "UBL-IDD-2.1-ES.xml" );
WScript.Echo( doc.parseError.line );