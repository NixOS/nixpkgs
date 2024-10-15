{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  setuptools-scm,
  packaging,
  tomli,

  # tests
  poppler-qt5,
  qgis,
  qgis-ltr,
}:

buildPythonPackage rec {
  pname = "sip";
  version = "6.8.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f8lZ5I5uxdWvi9Am9p9eJNCLPLirs0IXb1q4AwzAfXo=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    packaging
    setuptools
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  # There aren't tests
  doCheck = false;

  pythonImportsCheck = [ "sipbuild" ];

  passthru.tests = {
    # test depending packages
    inherit poppler-qt5 qgis qgis-ltr;
  };

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage = "https://riverbankcomputing.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nrdxp ];
  };
}
