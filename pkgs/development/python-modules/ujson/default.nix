{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "ujson";
  version = "5.2.0";
  disabled = isPyPy || pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FjGRuIhC2HTggXB9Nd4uIF4OOW5w/QaNEDiHm8qLF60=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ujson" ];

  meta = with lib; {
    description = "Ultra fast JSON encoder and decoder";
    homepage = "https://github.com/ultrajson/ultrajson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
