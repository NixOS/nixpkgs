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
  version = "5.1.0";
  disabled = isPyPy || pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "017h7r04cgjsnrpj21qbvvnn1djmgvrq2gf6l0y1mdwxz79492d8";
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
