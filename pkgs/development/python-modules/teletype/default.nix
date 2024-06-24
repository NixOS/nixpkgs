{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "teletype";
  version = "1.3.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uBppM4w9GlMgYqKFGw1Rcjvq+mnU04K3E74jCgK9YYo=";
  };

  nativeBuildInputs = [ setuptools ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "teletype" ];

  meta = with lib; {
    description = "High-level cross platform tty library";
    homepage = "https://github.com/jkwill87/teletype";
    license = licenses.mit;
    maintainers = with maintainers; [ urlordjames ];
  };
}
