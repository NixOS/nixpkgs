{ lib
, buildPythonPackage
, fetchPypi
, python
, yacs
, boxx
}:

buildPythonPackage rec {
  pname = "zcs";
  version = "0.1.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+0lG2OirfXj55IFA9GMERVWtrWwULfVfdbIg8ebH+7M=";
  };

  patches = [
    ./fix-test-yaml.patch
  ];

  propagatedBuildInputs = [ yacs ];

  pythonImportsCheck = [ "zcs" ];

  checkInputs = [ boxx ];
  checkPhase = ''
    ${python.interpreter} test/test_zcs.py
  '';

  meta = with lib; {
    description = "A flexible powerful configuration system which takes advantage of both argparse and yacs";
    homepage = "https://github.com/DIYer22/zcs";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
