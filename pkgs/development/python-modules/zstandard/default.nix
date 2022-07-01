{ lib
, buildPythonPackage
, fetchPypi
, cffi
, hypothesis
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa9194cb91441df7242aa3ddc4cb184be38876cb10dd973674887f334bafbfb6";
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
