{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  paramiko,
}:

buildPythonPackage rec {
  pname = "unifi-ap";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tofuSCHNITZEL";
    repo = "unifi_ap";
    rev = "refs/tags/v${version}";
    hash = "sha256-LQqeXFtrOc1h3yJuDrFRt3mqVcDIJb/23rcu/l6YpUQ=";
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
