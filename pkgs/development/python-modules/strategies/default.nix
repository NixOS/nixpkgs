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
    sha256 = "02i4ydrs9k61p8iv2vl2akks8p9gc88rw8031wlwb1zqsyjmb328";
  };

  propagatedBuildInputs = [
    multipledispatch
    toolz
  ];
  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "Python library for control flow programming";
    homepage = "https://github.com/logpy/strategies";
    license = licenses.mit;
    maintainers = with maintainers; [ suhr ];
  };
}
