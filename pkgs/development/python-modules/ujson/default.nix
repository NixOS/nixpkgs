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
  version = "4.2.0";
  disabled = isPyPy || pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fffe509f556861c7343c6cba57ed05fe7bcf4b48a934a5b946ccb45428cf8883";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ujson" ];

  meta = with lib; {
    description = "Ultra fast JSON encoder and decoder for Python";
    homepage = "https://pypi.python.org/pypi/ujson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
