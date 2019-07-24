{ lib
, fetchFromGitHub
, python
, buildPythonPackage
, gfortran
, nose
, pytest
, numpy
, cython
}:

buildPythonPackage rec {
  pname = "scipy";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "17xfnn7r21z7ncclmlgi6r9d5rxihnybzgdfby557i14zqklvk1c";
  };

  nativeBuildInputs = [
    gfortran
    cython
  ];

  buildInputs = [
    numpy.blas
  ];

  checkInputs = [
    nose
    pytest
  ];

  propagatedBuildInputs = [
    numpy
  ];

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
    maintainers = with lib.maintainers; [ fridh costrouc ];
  };
}
