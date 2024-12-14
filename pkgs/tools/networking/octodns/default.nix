{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  fqdn,
  idna,
  natsort,
  pytestCheckHook,
  python-dateutil,
  python3,
  pythonOlder,
  pyyaml,
  runCommand,
  setuptools,
}:

buildPythonPackage rec {
  pname = "octodns";
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns";
    rev = "refs/tags/v${version}";
    hash = "sha256-L3c4lYt/fgMctJFArc1XlR+hvpz10kcBcYYXajnNQr0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dnspython
    fqdn
    idna
    natsort
    python-dateutil
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "octodns" ];

  passthru.withProviders =
    ps:
    let
      pyEnv = python3.withPackages ps;
    in
    runCommand "octodns-with-providers" { } ''
      mkdir -p $out/bin
      ln -st $out/bin ${pyEnv}/bin/octodns-*
    '';

  meta = with lib; {
    description = "Tools for managing DNS across multiple providers";
    homepage = "https://github.com/octodns/octodns";
    changelog = "https://github.com/octodns/octodns/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.anthonyroussel ];
  };
}
