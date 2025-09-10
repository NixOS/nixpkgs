{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  ifaddr,
  pyserial,
}:

buildPythonPackage rec {
  pname = "toptica-lasersdk";
  version = "3.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "toptica_lasersdk";
    inherit version;
    hash = "sha256-VzgQCqfZP9JoFmotG0jPJpHMxLY+unNZqzxQGhtlYC4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    ifaddr
    pyserial
  ];

  pythonImportsCheck = [
    "toptica.lasersdk.dlcpro.v2_2_0"
  ];

  meta = {
    description = "TOPTICA Python Laser SDK";
    homepage = "https://toptica.github.io/python-lasersdk/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
