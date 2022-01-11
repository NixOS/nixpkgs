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
  version = "4.3.0";
  disabled = isPyPy || pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "baee56eca35cb5fbe02c28bd9c0936be41a96fa5c0812d9d4b7edeb5c3d568a0";
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
