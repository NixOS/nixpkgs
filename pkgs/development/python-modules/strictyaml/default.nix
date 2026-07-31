{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ruamel-yaml,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "strictyaml";
  version = "1.7.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IvhUpfyrQrXduoAwoOS+UcqJrwJnlhyNbPqGOVWGxAc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "ruamel.yaml==0.17.4" "ruamel.yaml"
  '';

  build-system = [ setuptools ];

  dependencies = [
    ruamel-yaml
    python-dateutil
  ];

  # Library tested with external tool
  # https://hitchdev.com/approach/contributing-to-hitch-libraries/
  doCheck = false;

  pythonImportsCheck = [ "strictyaml" ];

  meta = {
    description = "Strict, typed YAML parser";
    homepage = "https://hitchdev.com/strictyaml/";
    changelog = "https://hitchdev.com/strictyaml/changelog/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
