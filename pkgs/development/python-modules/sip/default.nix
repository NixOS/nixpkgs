{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  packaging,

  # tests
  poppler-qt5,
  qgis,
  qgis-ltr,
}:

buildPythonPackage rec {
  pname = "sip";
  version = "6.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CDztlPhTFUkyMRGaY5cLK6QrHTizjnMKcOAqmRkaicY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    setuptools
  ];

  # There aren't tests
  doCheck = false;

  pythonImportsCheck = [ "sipbuild" ];

  passthru.tests = {
    # test depending packages
    inherit poppler-qt5 qgis qgis-ltr;
  };

  meta = {
    description = "Creates C++ bindings for Python modules";
    homepage = "https://riverbankcomputing.com/";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
