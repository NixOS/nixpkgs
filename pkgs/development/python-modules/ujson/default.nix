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
  version = "5.3.0";
  disabled = isPyPy || pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-q5OHd7OsA3IjHuZUp/ahN4flh7HKJo2Kp+b7aEbkd9A=";
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
