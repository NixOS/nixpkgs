{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, ruamel-yaml
, python-dateutil
}:

buildPythonPackage rec {
  version = "1.6.0";
  pname = "strictyaml";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "73fa9769214a310486d7916453a09bd38b07d28a9dcbdf27719183c1d7d949f6";
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
