{ lib
, stdenv
, fetchPypi
, python
, buildPythonPackage
, gfortran
, nose
, pytest
, pytest-xdist
, numpy
, pybind11
}:

buildPythonPackage rec {
  pname = "scipy";
  version = "1.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a75b014d3294fce26852a9d04ea27b5671d86736beb34acdfc05859246260707";
  };

  checkInputs = [ nose pytest pytest-xdist ];
  nativeBuildInputs = [ gfortran ];
  buildInputs = [ numpy.blas pybind11 ];
  propagatedBuildInputs = [ numpy ];

  # Remove tests because of broken wrapper
  prePatch = ''
    rm scipy/linalg/tests/test_lapack.py
  '';

  doCheck = true;

  preConfigure = ''
    sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py
    export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
  '';

  preBuild = ''
    ln -s ${numpy.cfg} site.cfg
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
    pushd dist
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
