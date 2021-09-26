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
    sha256 = "sha256-//5Qn1VoYcc0PGy6V+0F/nvPS0ipNKW5Rsy0VCjPiIM=";
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
