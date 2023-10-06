{ lib
, buildPythonPackage
, fetchPypi
, cffi
, hypothesis
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.20.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YT2q3XLHGxSIdCyvssOzgcOdDJu4xswVeqLV6kXMLvw=";
  };

  propagatedNativeBuildInputs = [
    cffi
  ];

  propagatedBuildInputs = [
    cffi
  ];

  nativeCheckInputs = [
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
