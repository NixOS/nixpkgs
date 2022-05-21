{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, toml
}:

buildPythonPackage rec {
  pname = "vulture";
  version = "2.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gZQ5KUp2tOC44Ixw11VlqM49wfbgNVjtEjpfK7c3wOo=";
  };

  propagatedBuildInputs = [
    toml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov vulture --cov-report=html --cov-report=term --cov-report=xml --cov-append" ""
  '';

  pythonImportsCheck = [
    "vulture"
  ];

  meta = with lib; {
    description = "Finds unused code in Python programs";
    homepage = "https://github.com/jendrikseipp/vulture";
    license = licenses.mit;
    maintainers = with maintainers; [ mcwitt ];
  };
}
