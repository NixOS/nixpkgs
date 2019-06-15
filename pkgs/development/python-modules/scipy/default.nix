{lib, fetchPypi, python, buildPythonPackage, gfortran, nose, pytest, numpy, fetchpatch}:

buildPythonPackage rec {
  pname = "scipy";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3bb4bd2aca82fb498247deeac12265921fe231502a6bc6edea3ee7fe6c40a7a";
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
