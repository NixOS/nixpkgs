{ lib
, fetchFromGitHub
, python
, buildPythonPackage
, gfortran
, nose
, pytest
, numpy
, cython
, pybind11
}:

buildPythonPackage rec {
  pname = "scipy";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "scipy";
    repo = pname;
    rev = "v${version}";
    sha256 = "14y8wz6xyp628jqakbwbbaxph6xq38pm45ivk228ss4w5nr1dksj";
  };

  nativeBuildInputs = [
    gfortran
    cython
  ];

  buildInputs = [
    numpy.blas
    pybind11
  ];

  checkInputs = [
    nose
    pytest
  ];

  propagatedBuildInputs = [
    numpy
  ];

  preConfigure = ''
    export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
    export HOME=$TMPDIR
  '';

  preBuild = ''
    ln -s ${numpy.cfg} site.cfg
  '';

  enableParallelBuilding = true;

  checkPhase = ''
    pushd dist
    ${python.interpreter} -c 'import scipy; scipy.test("fast", verbose=10)'
    popd
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
