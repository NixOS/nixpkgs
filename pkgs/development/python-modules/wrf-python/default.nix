{ stdenv
, lib
, fetchFromGitHub
, pythonOlder
, buildPythonPackage
, basemap
, gfortran
, netcdf4
, numpy
, python
, setuptools
, xarray
, wrapt
}:

buildPythonPackage rec {
  pname = "wrf-python";
  version = "1.3.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NCAR";
    repo = "wrf-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-4iIs/M9fzGJsnKCDSl09OTUoh7j6REBXuutE5uXFe3k=";
  };

  nativeBuildInputs = [
    gfortran
  ];

  propagatedBuildInputs = [
    basemap
    numpy
    setuptools
    xarray
    wrapt
  ];

  nativeCheckInputs = [
    netcdf4
  ];

  checkPhase = ''
    runHook preCheck
    cd ./test/ci_tests
    ${python.interpreter} utests.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "wrf"
  ];

  meta = with lib; {
    description = "WRF postprocessing library for Python";
    homepage = "http://wrf-python.rtfd.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ mhaselsteiner ];
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
  };
}
