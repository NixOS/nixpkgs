{lib, fetchFromGitHub, python, pythonOlder, buildPythonPackage, gfortran, mock, xarray, wrapt, numpy, netcdf4}:

buildPythonPackage rec {
  pname = "wrf-python";
  version = "1.3.1.1";

  src = fetchFromGitHub {
    owner = "NCAR";
    repo = "wrf-python";
    rev = version;
    sha256 = "12mm7x1r5md6x28vmwyh6k655pgsv6knj8ycmjbxxk8bk7qsj74h";
  };

  propagatedBuildInputs = [
    wrapt
    numpy
    xarray
  ];
  buildInputs = [
    gfortran
  ] ++ lib.optional (pythonOlder "3.3") mock;
  
  checkInputs = [
    netcdf4
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    cd ./test/ci_tests
    python utests.py
    runHook postCheck
  '';

  meta = {
    description = "WRF postprocessing library for Python";
    homepage = http://wrf-python.rtfd.org;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mhaselsteiner ];
	};
}