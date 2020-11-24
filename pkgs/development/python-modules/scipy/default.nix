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
  version = "1.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a453d5e5689de62e5d38edf40af3f17560bfd63c9c5bd228c18c1f99afa155b";
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

  enableParallelBuilding = true;

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
