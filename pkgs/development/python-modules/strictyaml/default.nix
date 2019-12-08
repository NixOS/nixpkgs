{ buildPythonPackage
, lib
, fetchPypi
, ruamel_yaml
, python-dateutil
}:

buildPythonPackage rec {
  version = "1.0.6";
  pname = "strictyaml";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd687a32577e0b832619ce0552eac86d6afad5fa7b61ab041bb765881c6a1f36";
  };

  propagatedBuildInputs = [ ruamel_yaml python-dateutil ];

  # Library tested with external tool
  # https://hitchdev.com/approach/contributing-to-hitch-libraries/
  doCheck = false;

  meta = with lib; {
    description = "Strict, typed YAML parser";
    homepage = https://hitchdev.com/strictyaml/;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
