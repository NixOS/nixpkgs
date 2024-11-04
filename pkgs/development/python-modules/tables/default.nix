{
  lib,
  fetchPypi,
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
  version = "3.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SqB6xzS5wDe66vRK7GTskCrSR/V4EbWfMMTjHTHxJs8=";
  };

  build-system = [
    blosc2
    cython
    setuptools
    sphinx
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
    substituteInPlace Makefile --replace "src doc" "src"
    # Force test suite to error when unittest runner fails
    substituteInPlace tables/tests/test_suite.py \
      --replace "return 0" "assert result.wasSuccessful(); return 0" \
      --replace "return 1" "assert result.wasSuccessful(); return 1"
    substituteInPlace requirements.txt \
      --replace "cython>=0.29.21" "" \
      --replace "blosc2~=2.0.0" "blosc2"
  '';

  # Regenerate C code with Cython
  preBuild = ''
    make distclean
  '';

  setupPyBuildFlags = [
    "--hdf5=${lib.getDev hdf5}"
    "--lzo=${lib.getDev lzo}"
    "--bzip2=${lib.getDev bzip2}"
    "--blosc=${lib.getDev c-blosc}"
    "--blosc2=${lib.getDev blosc2.c-blosc2}"
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
    maintainers = with maintainers; [ drewrisinger ];
  };
}
