{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, cython
, pybind11
, tiledb
, numpy
, wheel
, isPy3k
, setuptools_scm
, psutil
, pandas
}:

buildPythonPackage rec {
  pname = "tiledb";
  version = "0.6.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "TileDB-Inc";
    repo = "TileDB-Py";
    rev = version;
    sha256 = "0b2kn1xyf7d994kz29dpqiaf8yzvx0axw4yqi854c54pl22ddgzl";
  };

  nativeBuildInputs = [
    cython
    pybind11
    setuptools_scm
  ];

  buildInputs = [
    tiledb
  ];

  propagatedBuildInputs = [
    numpy
    wheel # No idea why but it is listed
  ];

  checkInputs = [
    psutil
    # optional
    pandas
  ];

  TILEDB_PATH = tiledb;

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  disabled = !isPy3k; # Not bothering with python2 anymore

  postPatch = ''
    # Hardcode path to shared object
    substituteInPlace tiledb/__init__.py --replace \
      'os.path.join(lib_dir, lib_name)' 'os.path.join("${tiledb}/lib", lib_name)'

    # Disable failing test
    substituteInPlace tiledb/tests/test_examples.py --replace \
      "test_docs" "dont_test_docs"
    # these tests don't always fail
    substituteInPlace tiledb/tests/test_libtiledb.py --replace \
      "test_varlen_write_int_subarray" "dont_test_varlen_write_int_subarray" \
      --replace "test_memory_cleanup" "dont_test_memory_cleanup" \
      --replace "test_ctx_thread_cleanup" "dont_test_ctx_thread_cleanup"
    substituteInPlace tiledb/tests/test_metadata.py --replace \
      "test_metadata_consecutive" "dont_test_metadata_consecutive"
  '';

  checkPhase = ''
    pushd "$TMPDIR"
    ${python.interpreter} -m unittest tiledb.tests.all.suite_test
    popd
  '';
  pythonImportsCheck = [ "tiledb" ];

  meta = with lib; {
    description = "Python interface to the TileDB storage manager";
    homepage = "https://github.com/TileDB-Inc/TileDB-Py";
    license = licenses.mit;
    maintainers = with maintainers; [ fridh ];
  };

}
