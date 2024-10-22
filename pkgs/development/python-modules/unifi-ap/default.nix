{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  paramiko,
}:

buildPythonPackage rec {
  pname = "unifi-ap";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tofuSCHNITZEL";
    repo = "unifi_ap";
    rev = "v${version}";
    hash = "sha256-dEaDRcQEx+n+zvxVHD58B1AdFj004L76AtVDesnP+gQ=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [ "paramiko" ];

  dependencies = [
    paramiko
  ];

  pythonImportsCheck = [
    "unifi_ap"
  ];

  doCheck = false; # no tests

  meta = {
    changelog = "https://github.com/tofuSCHNITZEL/unifi_ap/releases/tag/v${version}";
    description = "Python API for UniFi accesspoints";
    homepage = "https://github.com/tofuSCHNITZEL/unifi_ap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
