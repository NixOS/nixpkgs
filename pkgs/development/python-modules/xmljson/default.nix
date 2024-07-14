{
  buildPythonPackage,
  fetchPypi,
  lib,
  lxml,
}:

buildPythonPackage rec {
  pname = "xmljson";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tBWOZqoeYu459/gOsv5PdnZwujwNXemARCDcU0J/3sg=";
  };

  nativeCheckInputs = [ lxml ];

  meta = with lib; {
    description = "Converts XML into dictionary structures and vice-versa";
    mainProgram = "xml2json";
    homepage = "https://github.com/sanand0/xmljson";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rakesh4g ];
  };
}
