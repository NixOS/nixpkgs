{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wrapio";
  version = "2.0.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CUocIbdZ/tJQCxAHzhFpB267ynlXf8Mu+thcRRc0yeg=";
  };

  doCheck = false;
  pythonImportsCheck = [ "wrapio" ];

  meta = with lib; {
    homepage = "https://github.com/Exahilosys/wrapio";
    description = "Handling event-based streams";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
