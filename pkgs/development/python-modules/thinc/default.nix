{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  blis,
  cymem,
  cython,
  murmurhash,
  numpy,
  preshed,
  setuptools,

  # buildInputs
  blas,

  # dependencies
  catalogue,
  confection,
  pydantic,
  srsly,
  wasabi,

  # tests
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "thinc";
  version = "8.3.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "thinc";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-8nf+AWAD7Fy50XRJDINmyk42F7KMDhGgATwqbln3r04=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail coverage.exceptions.CoverageWarning ""
  '';

  build-system = [
    blis
    cymem
    cython
    murmurhash
    numpy
    preshed
    setuptools
  ];

  buildInputs = [
    blas
  ];

  dependencies = [
    blis
    catalogue
    confection
    cymem
    murmurhash
    numpy
    preshed
    pydantic
    srsly
    wasabi
  ];

  pythonImportsCheck = [ "thinc" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  # avoid local paths, relative imports wont resolve correctly
  preCheck = ''
    mv thinc/tests tests
    rm -r thinc
  '';

  pytestFlags = [
    # UserWarning: Core Pydantic V1 functionality isn't compatible with Python 3.14 or greater.
    "-Wignore::UserWarning"
  ];

  disabledTestPaths = [
    # pydantic.v1.error_wrappers.ValidationError: 1 validation error for DefaultsSchema
    "tests/test_config.py"
  ];

  disabledTests = [
    # RecursionError: Stack overflow (used 8148 kB)
    "test_pickle_with_flatten"
  ];

  meta = {
    description = "Library for NLP machine learning";
    homepage = "https://github.com/explosion/thinc";
    changelog = "https://github.com/explosion/thinc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
