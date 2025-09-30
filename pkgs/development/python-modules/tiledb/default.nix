{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  pybind11,
  tiledb,
  numpy,
  wheel,
  isPy3k,
  setuptools-scm,
  psutil,
  pandas,
  cmake,
  ninja,
  scikit-build-core,
  packaging,
  pytest,
  hypothesis,
  pyarrow,
}:

buildPythonPackage rec {
  pname = "tiledb";
  version = "0.35.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "TileDB-Inc";
    repo = "TileDB-Py";
    tag = version;
    hash = "sha256-uxfF2uyGlO1Dfsrw0hxuU6LmymWXmuvOe+9DEY8BEdQ=";
  };

  build-system = [
    cython
    pybind11
    setuptools-scm
    scikit-build-core
    packaging
    cmake
    ninja
  ];

  buildInputs = [ tiledb ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    psutil
    # optional
    pandas
    pytest
    hypothesis
    pyarrow
  ];

  TILEDB_PATH = tiledb;

  disabled = !isPy3k; # Not bothering with python2 anymore

  dontUseCmakeConfigure = true;

  # We have to run pytest from a diffferent directory to force it to import tiledb from $out
  # otherwise it cannot be imported because extension modules are not compiled in sources
  checkPhase = ''
    pushd "$TMPDIR"
    ${python.interpreter} -m pytest --pyargs tiledb${lib.optionalString stdenv.isDarwin " -k 'not test_ctx_thread_cleanup and not test_array'"}
    popd
  '';

  pythonImportsCheck = [ "tiledb" ];

  meta = {
    description = "Python interface to the TileDB storage manager";
    homepage = "https://github.com/TileDB-Inc/TileDB-Py";
    license = lib.licenses.mit;
  };
}
