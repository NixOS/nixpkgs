{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  octodns,
  ovh,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "octodns-ovh";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-ovh";
    tag = "v${version}";
    hash = "sha256-/OiQQ+RkkL17E7R3Xz55R58SVJQPisURNhxgmpTvgu0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    ovh
    requests
  ];

  pythonImportsCheck = [ "octodns_ovh" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  disabledTests = [ "test_apply" ];

  meta = {
    description = "OVHcloud DNS v6 API provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-ovh/";
    changelog = "https://github.com/octodns/octodns-ovh/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nifoc ];
  };
}
