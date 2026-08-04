{
  lib,
  buildPythonPackage,
  fetchPypi,
  multipledispatch,
  toolz,
  setuptools,
  pytest,
}:

buildPythonPackage rec {
  pname = "strategies";
  version = "0.2.3";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "02i4ydrs9k61p8iv2vl2akks8p9gc88rw8031wlwb1zqsyjmb328";
  };

  build-system = [ setuptools ];

  dependencies = [
    multipledispatch
    toolz
  ];
  nativeCheckInputs = [ pytest ];

  meta = {
    description = "Python library for control flow programming";
    homepage = "https://github.com/logpy/strategies";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ suhr ];
  };
}
