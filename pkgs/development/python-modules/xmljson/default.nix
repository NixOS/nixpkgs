{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  lxml,
}:

buildPythonPackage (finalAttrs: {
  pname = "xmljson";
  version = "0.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-tBWOZqoeYu459/gOsv5PdnZwujwNXemARCDcU0J/3sg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ lxml ];

  pythonImportsCheck = [ "xmljson" ];

  meta = {
    description = "Converts XML into dictionary structures and vice-versa";
    mainProgram = "xml2json";
    homepage = "https://github.com/sanand0/xmljson";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
})
