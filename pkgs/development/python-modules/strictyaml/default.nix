{ buildPythonPackage
, lib
, fetchPypi
, ruamel_yaml
, python-dateutil
}:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "strictyaml";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1baz5zjl1z9dwaczaga1ik1iy1v9zg3acwnpmgghwnk9hw2i1mq6";
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
