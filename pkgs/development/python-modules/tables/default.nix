{ lib
, fetchPypi
, fetchpatch
, buildPythonPackage
, pythonOlder
, bzip2
, c-blosc
, cython
, hdf5
, lzo
, numpy
, numexpr
, packaging
  # Test inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tables";
  version = "3.7.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6SqIetbyqYPlZKaZAt5KdkXDAGn8AavTU+xdolXF4f4=";
  };

  nativeBuildInputs = [ cython ];

  buildInputs = [
    bzip2
    c-blosc
    hdf5
    lzo
  ];
  propagatedBuildInputs = [
    numpy
    numexpr
    packaging  # uses packaging.version at runtime
  ];

  # When doing `make distclean`, ignore docs
  postPatch = ''
    substituteInPlace Makefile --replace "src doc" "src"
    # Force test suite to error when unittest runner fails
    substituteInPlace tables/tests/test_suite.py \
      --replace "return 0" "assert result.wasSuccessful(); return 0" \
      --replace "return 1" "assert result.wasSuccessful(); return 1"
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
  ];

  checkInputs = [ pytestCheckHook ];
  preCheck = ''
    cd ..
  '';
  # Runs the test suite as one single test via unittest. The whole "heavy" test suite supposedly takes ~5 hours to run.
  pytestFlagsArray = [
    "--pyargs"
    "tables.tests.test_suite"
  ];

  pythonImportsCheck = [ "tables" ];

  meta = with lib; {
    description = "Hierarchical datasets for Python";
    homepage = "https://www.pytables.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
