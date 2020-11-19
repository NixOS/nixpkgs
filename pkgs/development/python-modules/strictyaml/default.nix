{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, ruamel_yaml
, python-dateutil
}:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "strictyaml";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b07dbd4f77ab023ed4167c43ffc1b9f9354fb6075cc6ff3b91fefcbb80342ca";
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
