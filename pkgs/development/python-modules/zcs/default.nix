{ lib
, buildPythonPackage
, fetchPypi
, python
, yacs
, boxx
}:

buildPythonPackage rec {
  pname = "zcs";
  version = "0.1.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Zs2aK+RR84uKjh+ZF/3gulS78zbb+XahTVSTJAArKHA=";
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
