{ buildPythonPackage
, lib
, fetchPypi
, ruamel_yaml
, python-dateutil
}:

buildPythonPackage rec {
  version = "1.0.5";
  pname = "strictyaml";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aad8d90c4d300c5bfa7678b9680ce456406319859c7279e98110548b596b5ae7";
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
