{lib, fetchPypi, python, buildPythonPackage, gfortran, nose, pytest, numpy, pybind11}:

let
  pybind = pybind11.overridePythonAttrs(oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DPYBIND11_TEST=off"
    ];
    doCheck = false; # Circular test dependency
  });
in buildPythonPackage rec {
  pname = "scipy";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rh5b1rwdcvvagld8vpxnpaibszy1skpx39a0fwzd5gx5pwcjvfb";
  };

  checkInputs = [ nose pytest ];
  nativeBuildInputs = [ gfortran ];
  buildInputs = [ numpy.blas pybind ];
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

  checkPhase = ''
    runHook preCheck
    pushd dist
    ${python.interpreter} -c 'import scipy; scipy.test("fast", verbose=10)'
    popd
    runHook postCheck
  '';

  passthru = {
    blas = numpy.blas;
  };

  setupPyBuildFlags = [ "--fcompiler='gnu95'" ];

  SCIPY_USE_G77_ABI_WRAPPER = 1;

  meta = {
    description = "SciPy (pronounced 'Sigh Pie') is open-source software for mathematics, science, and engineering. ";
    homepage = "https://www.scipy.org/";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
