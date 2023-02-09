{ lib
, stdenv
, fetchPypi
, python
, pythonOlder
, buildPythonPackage
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
, libxcrypt
}:

buildPythonPackage rec {
  pname = "scipy";
  version = "1.9.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+8XAXIXBoCvnex/1kQh8g7xEV5xtK9n7eYu2TqXhoCc=";
  };

  nativeBuildInputs = [ cython gfortran meson-python pythran pkg-config wheel ];

  buildInputs = [
    numpy.blas
    pybind11
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

  checkPhase = ''
    runHook preCheck
    pushd "$out"
    export OMP_NUM_THREADS=$(( $NIX_BUILD_CORES / 4 ))
    ${python.interpreter} -c "import scipy; scipy.test('fast', verbose=10, parallel=$NIX_BUILD_CORES)"
    popd
    runHook postCheck
  '';

  passthru = {
    blas = numpy.blas;
  };

  setupPyBuildFlags = [ "--fcompiler='gnu95'" ];

  SCIPY_USE_G77_ABI_WRAPPER = 1;

  meta = with lib; {
    description = "SciPy (pronounced 'Sigh Pie') is open-source software for mathematics, science, and engineering";
    homepage = "https://www.scipy.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.fridh ];
  };
}
