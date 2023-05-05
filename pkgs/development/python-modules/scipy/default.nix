{ lib
, stdenv
, fetchPypi
, pypaBuildHook
, python
, pythonOlder
, buildPythonPackage
, blas
, lapack
, cython
, gfortran
, meson-python
, pkg-config
, pythran
, wheel
, nose
, pytest
, pytest-xdist
, numpy
, pybind11
, pooch
, libxcrypt
}:

assert blas.provider == numpy.blas;

buildPythonPackage rec {
  pname = "scipy";
  version = "1.10.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LPnfuAp7RYm6TEDOdYiYbW1c68VFfK0sKID2vC1C86U=";
  };

  patches = [
    # These tests require internet connection, currently impossible to disable
    # them otherwise, see:
    # https://github.com/scipy/scipy/pull/17965
    ./disable-datasets-tests.patch
  ];

  # The pybind11 issue seems to have already been address by 2.10.3
  # https://github.com/pybind/pybind11/issues/4420
  #
  # We should update pythran
  #
  # Numpy is pinned at patch versions, probably as a way to choose from a set
  # of wheels published in pypi?
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "pybind11==2.10.1" "pybind11>=2.10.3" \
      --replace '"pythran>=0.12.0,<0.13.0",' "" \
      --replace "numpy==" "numpy>="
  '';

  nativeBuildInputs = [
    pypaBuildHook
    cython
    gfortran
    meson-python
    pythran
    pkg-config
    wheel
  ];

  buildInputs = [
    blas
    lapack
    pybind11
    pooch
  ] ++ lib.optionals (pythonOlder "3.9") [
    libxcrypt
  ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ nose pytest pytest-xdist ];

  doCheck = !(stdenv.isx86_64 && stdenv.isDarwin);

  preConfigure = ''
    sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py
    export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
  '';

  # disable stackprotector on aarch64-darwin for now
  #
  # build error:
  #
  # /private/tmp/nix-build-python3.9-scipy-1.6.3.drv-0/ccDEsw5U.s:109:15: error: index must be an integer in range [-256, 255].
  #
  #         ldr     x0, [x0, ___stack_chk_guard];momd
  #
  hardeningDisable = lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [ "stackprotector" ];

  dontUsePipBuild = true;
  pypaBuildFlags = [
    # Skip sdist
    "--wheel"

    "-Csetup-args=-Dblas=cblas"
    "-Csetup-args=-Dlapack=lapacke"
  ];

  checkPhase = ''
    runHook preCheck
    pushd "$out"
    export OMP_NUM_THREADS=$(( $NIX_BUILD_CORES / 4 ))
    ${python.interpreter} -c "import scipy; scipy.test('fast', verbose=10, parallel=$NIX_BUILD_CORES)"
    popd
    runHook postCheck
  '';

  requiredSystemFeatures = [ "big-parallel" ]; # the tests need lots of CPU time

  passthru = {
    blas = numpy.blas;
  };

  SCIPY_USE_G77_ABI_WRAPPER = 1;

  meta = with lib; {
    description = "SciPy (pronounced 'Sigh Pie') is open-source software for mathematics, science, and engineering";
    homepage = "https://www.scipy.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.fridh ];
  };
}
