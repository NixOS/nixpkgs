{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wrapio";
  version = "0.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jGupLh+xzwil+VBtAjIG+ZYT+dy+QaZOTIfipTQeyWo";
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
