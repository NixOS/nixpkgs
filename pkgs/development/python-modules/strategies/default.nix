{
  lib,
  buildPythonPackage,
  fetchPypi,
  multipledispatch,
  toolz,
  pytest,
}:

buildPythonPackage rec {
  pname = "strategies";
  version = "0.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SIxVpdf4h8UpDwMgnhFiL12k51SCbrEjusHMpHPzJAo=";
  };

  propagatedBuildInputs = [
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
