{lib, fetchPypi, python, buildPythonPackage, gfortran, nose, pytest, numpy}:

buildPythonPackage rec {
  pname = "scipy";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64bf4e8ae0db2d42b58477817f648d81e77f0b381d0ea4427385bba3f959380a";
  };

  checkInputs = [ nose pytest ];
  nativeBuildInputs = [ gfortran ];
  buildInputs = [ numpy.blas ];
  propagatedBuildInputs = [ numpy ];

  # Remove tests because of broken wrapper
  prePatch = ''
    rm scipy/linalg/tests/test_lapack.py
  '';

  # INTERNALERROR, solved with https://github.com/scipy/scipy/pull/8871
  # however, it does not apply cleanly.
  doCheck = false;

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

  meta = {
    description = "SciPy (pronounced 'Sigh Pie') is open-source software for mathematics, science, and engineering. ";
    homepage = https://www.scipy.org/;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
