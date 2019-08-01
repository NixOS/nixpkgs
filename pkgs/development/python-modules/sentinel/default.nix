{ lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "sentinel";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c00ba2a4f240ea4c5414059a696d6e128730272cb2c631b2eff42e86da1f89b3";
  };

  meta = with lib; {
    description = "Create sentinel and singleton objects";
    homepage = "https://github.com/eddieantonio/sentinel";
    license = licenses.mit;
  };
}
