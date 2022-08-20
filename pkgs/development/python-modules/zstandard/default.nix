{ lib
, buildPythonPackage
, fetchPypi
, cffi
, hypothesis
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CsA1eg2YW0/zGoVHRAQNe1dUOF0fmPcUXDDgLGhly28=";
  };

  propagatedNativeBuildInputs = [
    cffi
  ];

  propagatedBuildInputs = [
    cffi
  ];

  checkInputs = [
    hypothesis
  ];

  pythonImportsCheck = [
    "zstandard"
  ];

  meta = with lib; {
    description = "zstandard bindings for Python";
    homepage = "https://github.com/indygreg/python-zstandard";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
