{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  octodns,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "octodns-powerdns";
  version = "0.0.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-powerdns";
    rev = "refs/tags/v${version}";
    hash = "sha256-wa/SHyTfj+iHnTq8t+3yzyGn+YULOdI88Aii16qPwPM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    requests
  ];

  env.OCTODNS_RELEASE = 1;

  pythonImportsCheck = [ "octodns_powerdns" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  meta = with lib; {
    description = "PowerDNS API provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-powerdns/";
    changelog = "https://github.com/octodns/octodns-powerdns/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
