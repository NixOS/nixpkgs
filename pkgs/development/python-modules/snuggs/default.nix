{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  setuptools,
  pyparsing,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage (finalAttrs: {
  pname = "snuggs";
  version = "1.4.7";
  pyproject = true;

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "snuggs";
    tag = finalAttrs.version;
    hash = "sha256-jj8H9Rgq0MSOObDiN3UXXtx67BY+jKTXz1ZTL3SCdNw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pyparsing
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  meta = {
    description = "S-expressions for Numpy";
    license = lib.licenses.mit;
    homepage = "https://github.com/mapbox/snuggs";
    maintainers = [ ];
  };
})
