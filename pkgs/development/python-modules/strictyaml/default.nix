{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, ruamel-yaml
, python-dateutil
}:

buildPythonPackage rec {
  version = "1.6.2";
  pname = "strictyaml";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cM1VmA/ikp3AOJJMoI9o+WFIIjqHd4EPphbjR46+cco=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "ruamel.yaml==0.17.4" "ruamel.yaml"
  '';

  propagatedBuildInputs = [ ruamel-yaml python-dateutil ];

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
