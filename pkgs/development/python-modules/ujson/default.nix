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
  version = "4.1.0";
  disabled = isPyPy || pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IrY+xECfDS8sTJ1aozGZfgJHC3oVoyM/PMMvL5uS1Yw=";
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
