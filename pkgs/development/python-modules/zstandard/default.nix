{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  cffi,
  setuptools,
  hypothesis,
  pytestCheckHook,
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

  # python-zstandard depends on unstable zstd C APIs and may break with version mismatches,
  # so we don't provide system zstd for this package
  # https://github.com/indygreg/python-zstandard/blob/9eb56949b1764a166845e065542690942a3203d3/c-ext/backend_c.c#L137-L150

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  preCheck = ''
    rm -r zstandard
  '';

  pythonImportsCheck = [ "zstandard" ];

  meta = {
    description = "Zstandard bindings for Python";
    homepage = "https://github.com/indygreg/python-zstandard";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ arnoldfarkas ];
  };
}
