{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, ruamel_yaml
, python-dateutil
}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "strictyaml";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f640ae4e6fe761c3ae7138092c3dcb9b5050ec56e9cbac45d8a6b549d7ec973c";
  };

  propagatedBuildInputs = [ ruamel_yaml python-dateutil ];

  # Library tested with external tool
  # https://hitchdev.com/approach/contributing-to-hitch-libraries/
  doCheck = false;
  pythonImportsCheck = [ "strictyaml" ];

  meta = with lib; {
    description = "Strict, typed YAML parser";
    homepage = "https://hitchdev.com/strictyaml/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
