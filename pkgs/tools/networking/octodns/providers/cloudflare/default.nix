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
  pname = "octodns-cloudflare";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-cloudflare";
    tag = "v${version}";
    hash = "sha256-VHmi/ClCZCruz0wSSZC81nhN7i31vK29TsYzyrRJNTY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    octodns
    requests
  ];

  pythonImportsCheck = [ "octodns_cloudflare" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  meta = {
    description = "Cloudflare API provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-cloudflare/";
    changelog = "https://github.com/octodns/octodns-cloudflare/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ret2pop ];
  };
}
