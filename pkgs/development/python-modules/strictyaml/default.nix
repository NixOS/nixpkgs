{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, ruamel-yaml
, python-dateutil
}:

buildPythonPackage rec {
  version = "1.6.1";
  pname = "strictyaml";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "688be16ee5d1a2f94aa4abdc6d881e8e254d173d724ac88725955fe66bdb63d4";
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
