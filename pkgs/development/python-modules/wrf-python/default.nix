{ stdenv
, lib
, fetchFromGitHub
, pythonOlder
, buildPythonPackage
, gfortran
, xarray
, wrapt
, numpy
, netcdf4
, setuptools
}:

buildPythonPackage rec {
  pname = "wrf-python";
  version = "1.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NCAR";
    repo = "wrf-python";
    rev = version;
    hash = "sha256-+v4FEK0FVE0oAIb18XDTOInHKfxXyykb1ngk9Uxwf0c=";
  };

  propagatedBuildInputs = [
    wrapt
    numpy
    setuptools
    xarray
  ];

  nativeBuildInputs = [
    gfortran
  ];

  checkInputs = [
    netcdf4
  ];

  checkPhase = ''
    runHook preCheck
    cd ./test/ci_tests
    python utests.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "wrf"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "WRF postprocessing library for Python";
    homepage = "http://wrf-python.rtfd.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ mhaselsteiner ];
  };
}
