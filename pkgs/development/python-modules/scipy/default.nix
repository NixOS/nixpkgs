{lib, fetchPypi, python, buildPythonPackage, isPyPy, gfortran, nose, pytest, numpy}:

buildPythonPackage rec {
  pname = "scipy";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87ea1f11a0e9ec08c264dc64551d501fa307289460705f6fccd84cbfc7926d10";
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
