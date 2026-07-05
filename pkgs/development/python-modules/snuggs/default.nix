{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  click,
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

  patches = [
    # Use non-strict xfail for failing tests
    # https://github.com/mapbox/snuggs/pull/28
    (fetchpatch {
      url = "https://github.com/sebastic/snuggs/commit/3b8e04a35ed33a7dd89f0194542b22c7bde867f4.patch";
      hash = "sha256-SfW4l4BH94rPdskRVHEsZM0twmlV9IPftRU/BBZsjBU=";
    })
  ];

  dependencies = [
    click
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
