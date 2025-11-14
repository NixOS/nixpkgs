{
  lib,
  stdenv,
  fetchPypi,
  fetchpatch,
  buildPythonPackage,
  pythonOlder,
  blosc2,
  bzip2,
  c-blosc,
  cython,
  hdf5,
  lzo,
  numpy,
  numexpr,
  packaging,
  pkg-config,
  setuptools,
  sphinx,
  typing-extensions,
  # Test inputs
  python,
  pytest,
  py-cpuinfo,
}:

buildPythonPackage rec {
  pname = "tables";
  version = "3.10.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JUSBKnGG+tuoMdbdNOtJzNeI1qg/TkwrQxuDW2eWyRA=";
  };

  patches = [
    # should be included in next release
    (fetchpatch {
      name = "numexpr-2.13.0-compat.patch";
      url = "https://github.com/PyTables/PyTables/commit/41270019ce1ffd97ce8f23b21d635e00e12b0ccb.patch";
      hash = "sha256-CaDBYKiABVtlM5e9ChCsf8dWOwEnMPOIXQ100JTnlnE=";
    })
  ];

  build-system = [
    blosc2
    cython
    setuptools
    sphinx
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    c-blosc
    blosc2.c-blosc2
    hdf5
    lzo
  ];

  dependencies = [
    blosc2
    py-cpuinfo
    numpy
    numexpr
    packaging # uses packaging.version at runtime
    typing-extensions
  ];

  # When doing `make distclean`, ignore docs
  postPatch = ''
    # Force test suite to error when unittest runner fails
    substituteInPlace tables/tests/test_suite.py \
      --replace-fail "return 0" "assert result.wasSuccessful(); return 0" \
      --replace-fail "return 1" "assert result.wasSuccessful(); return 1"
    substituteInPlace tables/__init__.py \
      --replace-fail 'find_library("blosc2")' '"${lib.getLib c-blosc}/lib/libblosc${stdenv.hostPlatform.extensions.sharedLibrary}"'  '';

  env = {
    HDF5_DIR = lib.getDev hdf5;
  };

  # Regenerate C code with Cython
  preBuild = ''
    make distclean
  '';

  pypaBuildFlags = [
    "--config-setting=--build-option=--hdf5=${lib.getDev hdf5}"
    "--config-setting=--build-option=--lzo=${lib.getDev lzo}"
    "--config-setting=--build-option=--bzip2=${lib.getDev bzip2}"
    "--config-setting=--build-option=--blosc=${lib.getDev c-blosc}"
    "--config-setting=--build-option=--blosc2=${lib.getDev blosc2.c-blosc2}"
  ];

  nativeCheckInputs = [ pytest ];

  preCheck = ''
    export HOME=$(mktemp -d)
    cd ..
  '';

  # Runs the light (yet comprehensive) subset of the test suite.
  # The whole "heavy" test suite supposedly takes ~4 hours to run.
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m tables.tests.test_all
    runHook postCheck
  '';

  pythonImportsCheck = [ "tables" ];

  meta = with lib; {
    description = "Hierarchical datasets for Python";
    homepage = "https://www.pytables.org/";
    changelog = "https://github.com/PyTables/PyTables/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
