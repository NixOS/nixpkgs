{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  wheel,
  cython,
  numpy,
  build,
  ta-lib,
}:

buildPythonPackage (finalAttrs: {
  pname = "ta-lib";
  version = "0.6.8";
  src = fetchFromGitHub {
    owner = "TA-Lib";
    repo = "ta-lib-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fgi/TkXb6UdjA8YohraW1Xn7aOLbNdt01SfCzyU0a2Y=";
  };
  pyproject = true;
  build-system = [
    setuptools
    wheel
    cython
    numpy
  ];
  dependencies = [
    build
    numpy
  ];
  buildInputs = [ ta-lib ];
  meta = {
    description = "Python wrapper for TA-Lib";
    homepage = "https://github.com/TA-Lib/ta-lib-python";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
