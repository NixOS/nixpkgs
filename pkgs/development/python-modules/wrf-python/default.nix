{lib, fetchFromGitHub, pythonOlder, buildPythonPackage, gfortran, mock, xarray, wrapt, numpy, netcdf4, setuptools}:

buildPythonPackage rec {
  pname = "wrf-python";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "NCAR";
    repo = "wrf-python";
    rev = version;
    sha256 = "1rklkki54z5392cpwwy78bnmsy2ghc187l3j7nv0rzn6jk5bvyi7";
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
  ] ++ lib.optional (pythonOlder "3.3") mock;

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
