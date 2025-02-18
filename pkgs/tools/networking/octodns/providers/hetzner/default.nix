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
  pname = "octodns-hetzner";
  # the latest release tag is over a year behind.
  version = "0.0.2-unstable-2023-09-29";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-hetzner";
    rev = "620840593a520dac9e365240b3ab361ded309c8e";
    hash = "sha256-WdYy8tc0+PYsKuyp3uqOzbxwhLSZ+06L3JVaTSATEKM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    octodns
    requests
  ];

  pythonImportsCheck = [ "octodns_hetzner" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  meta = with lib; {
    description = "Hetzner DNS provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-hetzner/";
    changelog = "https://github.com/octodns/octodns-hetzner/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
