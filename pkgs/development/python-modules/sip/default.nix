{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  packaging,
  ply,
  toml,
  tomli,

  # tests
  poppler-qt5,
  qgis,
  qgis-ltr,
}:

buildPythonPackage rec {
  pname = "sip";
  version = "6.8.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iIVHsBi7JMNq3tUZ6T0+UT1MaqC6VbfMGv+9Rc8Qdiw=";
  };

  nativeBuildInputs = [ setuptools ];

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
