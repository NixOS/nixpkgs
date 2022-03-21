{ lib
, buildPythonPackage
, fetchPypi
, python
, yacs
, boxx
}:

buildPythonPackage rec {
  pname = "zcs";
  version = "0.1.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZoQgAaJy3kKHLljyKA0Oo/D1kefE8X9FlsGDSNt1nPw=";
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
