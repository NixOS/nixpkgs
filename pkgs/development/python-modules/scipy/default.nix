{lib, fetchPypi, python, buildPythonPackage, gfortran, nose, pytest, numpy}:

buildPythonPackage rec {
  pname = "scipy";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fj0r7bg0cfk5clvl57ga06y9bfh05iwlv1dqqs1r6pd89wccfc7";
  };

  checkInputs = [ nose pytest ];
  buildInputs = [ gfortran numpy.blas ];
  propagatedBuildInputs = [ numpy ];

  # Remove tests because of broken wrapper
  prePatch = ''
    rm scipy/linalg/tests/test_lapack.py
  '';

  preConfigure = ''
    sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py
    export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
  '';

  preBuild = ''
    echo "Creating site.cfg file..."
    cat << EOF > site.cfg
    [openblas]
    include_dirs = ${numpy.blas}/include
    library_dirs = ${numpy.blas}/lib
    EOF
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
    homepage = http://www.scipy.org/;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
