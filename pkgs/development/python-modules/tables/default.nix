{ lib
, fetchPypi
, fetchurl
, fetchpatch
, buildPythonPackage
, pythonOlder
, python
, bzip2
, c-blosc
, cython
, hdf5
, lzo
, numpy
, numexpr
, setuptools
  # Test inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tables";
  version = "3.6.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0j8vnxh2m5n0cyk9z3ndcj5n1zj5rdxgc1gb78bqlyn2lyw75aa9";
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
    setuptools  # uses pkg_resources at runtime
  ];

  patches = [
    (fetchpatch {
      # Needed for numpy >= 1.20.0
      name = "tables-pr-862-use-lowercase-numpy-dtypes.patch";
      url = "https://github.com/PyTables/PyTables/commit/93a3272b8fe754095637628b4d312400e24ae654.patch";
      sha256 = "00czgxnm1dxp9763va9xw1nc7dd7kxh9hjcg9klim52519hkbhi4";
    })
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
