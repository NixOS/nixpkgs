{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wrapio";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CUocIbdZ/tJQCxAHzhFpB267ynlXf8Mu+thcRRc0yeg=";
  };

  doCheck = false;
  pythonImportsCheck = [ "wrapio" ];

  meta = with lib; {
    description = "Handling event-based streams";
    homepage = "https://github.com/Exahilosys/wrapio";
    changelog = "https://github.com/Exahilosys/wrapio/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
