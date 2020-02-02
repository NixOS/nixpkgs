{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, cython
, tiledb
, numpy
, wheel
, isPy3k
, setuptools_scm
, psutil
}:

buildPythonPackage rec {
  pname = "tiledb";
  version = "0.5.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "TileDB-Inc";
    repo = "TileDB-Py";
    rev = version;
    sha256 = "1wzzq3ggrprnjqgx9168r4x8cj1rh2ikr6mlxgbi463p5hnlkb5m";
  };

  nativeBuildInputs = [
    cython
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
  '';

  checkPhase = ''
    pushd "$out"
    ${python.interpreter} -m unittest tiledb.tests.all.suite_test
    popd
  '';

  meta = with lib; {
    description = "Python interface to the TileDB storage manager";
    homepage = https://github.com/TileDB-Inc/TileDB-Py;
    license = licenses.mit;
    maintainers = with maintainers; [ fridh ];
  };

}