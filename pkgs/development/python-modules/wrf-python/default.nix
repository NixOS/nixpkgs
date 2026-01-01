{
  lib,
  fetchFromGitHub,
  pythonOlder,
  buildPythonPackage,
  basemap,
  gfortran,
  netcdf4,
  numpy,
  python,
  setuptools,
  xarray,
  wrapt,
}:

buildPythonPackage rec {
  pname = "wrf-python";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NCAR";
    repo = "wrf-python";
    tag = "v${version}";
    hash = "sha256-LvNorZ28j/O8fs9z6jhYWC8RcCDIwh7k5iR9iumCvnQ=";
  };

  nativeBuildInputs = [ gfortran ];

  propagatedBuildInputs = [
    basemap
    numpy
    setuptools
    xarray
    wrapt
  ];

  nativeCheckInputs = [ netcdf4 ];

  checkPhase = ''
    runHook preCheck
    cd ./test/ci_tests
    ${python.interpreter} utests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "wrf" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # `ModuleNotFoundError: No module named 'distutils.msvccompiler'` on Python 3.11
    # `ModuleNotFoundError: No module named 'numpy.distutils'` on Python 3.12
    broken = true;
    description = "WRF postprocessing library for Python";
    homepage = "http://wrf-python.rtfd.org";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mhaselsteiner ];
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ mhaselsteiner ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
