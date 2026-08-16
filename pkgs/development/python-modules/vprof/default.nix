{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  psutil,
}:

buildPythonPackage rec {
  pname = "vprof";
  version = "0.38";
  pyproject = true;

  # We use the Pypi source rather than the GitHub ones because the former include the javascript
  # dependency for the UI.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fxAAkS7rekUMfJTTzJZzmvRa0P8B1avMCwmhddQP+ts=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ psutil ];

  pythonImportsCheck = [ "vprof" ];

  # The tests are not included in the Pypi sources
  doCheck = false;

  meta = {
    description = "Visual profiler for Python";
    homepage = "https://github.com/nvdv/vprof";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "vprof";
  };
}
