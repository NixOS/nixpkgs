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
  format = "setuptools";

  disabled = isPyPy || pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uu5W7KNctfvgLCi9nAk2vkGpb6XAgS2dS37etcPVaKA=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ujson"
  ];

  meta = with lib; {
    description = "Ultra fast JSON encoder and decoder for Python";
    homepage = "https://pypi.python.org/pypi/ujson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
