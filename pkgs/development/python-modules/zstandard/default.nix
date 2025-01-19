{
  lib,
  buildPythonPackage,
  fetchPypi,
  cffi,
  hypothesis,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.23.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-stjGLQjnJV9o96dAuuhbPJuOVGa6qcv39X8c3grGvAk=";
  };

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  nativeCheckInputs = [ hypothesis ];

  pythonImportsCheck = [ "zstandard" ];

  meta = {
    description = "zstandard bindings for Python";
    homepage = "https://github.com/indygreg/python-zstandard";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ arnoldfarkas ];
  };
}
