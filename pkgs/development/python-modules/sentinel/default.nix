{ lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "sentinel";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7aeee3f57c56a8e52771fc64230345deecd62c48debbbe1f1aca453439741d0";
  };

  meta = with lib; {
    description = "Create sentinel and singleton objects";
    homepage = "https://github.com/eddieantonio/sentinel";
    license = licenses.mit;
  };
}
