{ lib, buildPythonPackage, fetchPypi
, pytest, heapdict, pythonOlder }:

buildPythonPackage rec {
  pname = "zict";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FbLMFflaR2++BiP9j3ceHncTEL96AflUEqC2BbbkdRA=";
  };

  disabled = pythonOlder "3.6";

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ heapdict ];

  meta = with lib; {
    description = "Mutable mapping tools.";
    homepage = "https://github.com/dask/zict";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
