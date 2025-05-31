{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  cffi,
  setuptools,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.23.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-stjGLQjnJV9o96dAuuhbPJuOVGa6qcv39X8c3grGvAk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<69.0.0" "setuptools" \
      --replace-fail "cffi==" "cffi>="
  '';

  build-system = [
    cffi
    setuptools
  ];

  dependencies = lib.optionals isPyPy [ cffi ];

  nativeCheckInputs = [ hypothesis ];

  pythonImportsCheck = [ "zstandard" ];

  meta = {
    description = "zstandard bindings for Python";
    homepage = "https://github.com/indygreg/python-zstandard";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ arnoldfarkas ];
  };
}
