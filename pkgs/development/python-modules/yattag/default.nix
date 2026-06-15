{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "yattag";
  version = "1.16.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uqjyVOfqXT4GGCga0v9WEODlNgs2COaVwpv7OynQUfQ=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "yattag" ];

  meta = {
    description = "Library to generate HTML or XML";
    homepage = "https://www.yattag.org/";
    license = lib.licenses.lgpl21Only;
    maintainers = [ ];
  };
})
