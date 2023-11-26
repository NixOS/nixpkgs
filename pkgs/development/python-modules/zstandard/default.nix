{ lib
, buildPythonPackage
, fetchPypi
, cffi
, hypothesis
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8I46ENAaJHh35MthqCoxnqdGw1ajeGVYvtJIHmxAVUY=";
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
