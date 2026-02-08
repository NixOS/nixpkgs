{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  taLib,
  cython,
  numpy,
  build,
}:
buildPythonPackage rec {
  pname = "ta-lib-python";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "TA-Lib";
    repo = "ta-lib-python";
    rev = "v${version}";
    sha256 = "fgi/TkXb6UdjA8YohraW1Xn7aOLbNdt01SfCzyU0a2Y=";
  };

  pyproject = true;

  build-system = [
    setuptools
    wheel
    cython
  ];

  env = {
    TA_INCLUDE_PATH = "${taLib}/include";
    TA_LIBRARY_PATH = "${taLib}/lib";
  };

  buildInputs = [
    taLib
  ];

  dependencies = [
    numpy
    build
  ];

  doCheck = false;

  pythonImportsCheck = [ "talib" ];

  meta = with lib; {
    description = "Python bindings for TA-Lib";
    homepage = "https://github.com/TA-Lib/ta-lib-python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ lpbigfish ];
  };
}
