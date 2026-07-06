{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  stdenv,

  # build-system
  cython,
  setuptools,
  sphinx,

  # build-inputs
  blosc2,
  bzip2,
  c-blosc,
  hdf5,
  lzo,
  pkg-config,

  # dependencies
  numexpr,
  numpy,
  packaging, # uses packaging.version at runtime
  py-cpuinfo,
  typing-extensions,

  # Test inputs
  python,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "tables";
  version = "3.11.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PyTables";
    repo = "PyTables";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ImzfUc+B5odozROkwhnDUY2a9XDXn8Il2wKuLzOvKAg=";
    fetchSubmodules = true;
  };

  build-system = [
    cython
    setuptools
    sphinx
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    blosc2
    bzip2
    c-blosc
    blosc2.c-blosc2
    hdf5
    lzo
  ];

  dependencies = [
    blosc2
    c-blosc
    blosc2.c-blosc2
    py-cpuinfo
    numpy
    numexpr
    packaging # uses packaging.version at runtime
    typing-extensions
  ];

  postPatch = ''
    # Force test suite to error when unittest runner fails
    substituteInPlace tables/tests/test_suite.py \
      --replace-fail "return 0" "assert result.wasSuccessful(); return 0" \
      --replace-fail "return 1" "assert result.wasSuccessful(); return 1"
    # Hard-code the blosc2 path to avoid issues with blosc2.c-blosc2
    substituteInPlace tables/__init__.py \
      --replace-fail "ctypes.CDLL(str(lib_path))" \
      "ctypes.CDLL('"${lib.getLib c-blosc}/lib/libblosc${stdenv.hostPlatform.extensions.sharedLibrary}"')"
  '';

  env = {
    HDF5_DIR = lib.getDev hdf5;
    LZO_DIR = lib.getDev lzo;
    BZIP2_DIR = lib.getDev bzip2;
    BLOSC_DIR = lib.getDev c-blosc;
    BLOSC2_DIR = lib.getDev blosc2.c-blosc2;
  };

  nativeCheckInputs = [
    python
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    cd tables/tests
  '';

  # Runs the light (yet comprehensive) subset of the test suite.
  # Pass `--heavy` for the whole "heavy" test suite (hour+ runtime).
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m tables.tests.test_all
    runHook postCheck
  '';

  pythonImportsCheck = [ "tables" ];

  meta = {
    description = "Hierarchical datasets for Python";
    homepage = "https://www.pytables.org/";
    changelog = "https://github.com/PyTables/PyTables/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
