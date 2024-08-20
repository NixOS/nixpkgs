{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  ruamel-yaml,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "strictyaml";
  version = "1.7.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IvhUpfyrQrXduoAwoOS+UcqJrwJnlhyNbPqGOVWGxAc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "ruamel.yaml==0.17.4" "ruamel.yaml"
  '';

  propagatedBuildInputs = [
    ruamel-yaml
    python-dateutil
  ];

  # Library tested with external tool
  # https://hitchdev.com/approach/contributing-to-hitch-libraries/
  doCheck = false;

  pythonImportsCheck = [ "strictyaml" ];

  meta = with lib; {
    description = "Strict, typed YAML parser";
    homepage = "https://hitchdev.com/strictyaml/";
    changelog = "https://hitchdev.com/strictyaml/changelog/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
