{ lib
, buildPythonPackage
, fetchPypi
, python
, yacs
, boxx
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zcs";
  version = "0.1.25";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/QIyRQtxLDVW+vcQi5bL8rJ0o3+OhqGhQEALR1YO1pg=";
  };

  patches = [
    ./fix-test-yaml.patch
  ];

  propagatedBuildInputs = [
    yacs
  ];

  pythonImportsCheck = [
    "zcs"
  ];

  checkInputs = [
    boxx
  ];

  checkPhase = ''
    ${python.interpreter} test/test_zcs.py
  '';

  meta = with lib; {
    description = "Configuration system which takes advantage of both argparse and yacs";
    homepage = "https://github.com/DIYer22/zcs";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
