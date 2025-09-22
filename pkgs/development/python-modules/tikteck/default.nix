{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  bluepy,
  pycryptodome,
}:

buildPythonPackage rec {
  pname = "tikteck";
  version = "0.4";
  pyproject = true;

  # github doesn't have any tags unfortunately
  src = fetchPypi {
    pname = "tikteck";
    inherit version;
    hash = "sha256-KEbGT2RXLFMQ49gltOYcbE+ebJ1kiXzhT0DIeVXsSJM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bluepy
    pycryptodome
  ];

  pythonImportsCheck = [ "tikteck" ];

  # no upstream tests exist
  doCheck = false;

  meta = {
    description = "Control Tikteck Bluetooth LED bulbs";
    homepage = "https://github.com/mjg59/python-tikteck";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
