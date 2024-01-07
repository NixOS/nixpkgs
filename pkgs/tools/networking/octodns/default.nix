{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, wheel
, pytestCheckHook
, dnspython
, fqdn
, idna
, natsort
, python-dateutil
, pyyaml
, python
, runCommand
}:

buildPythonPackage rec {
  pname = "octodns";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns";
    rev = "v${version}";
    hash = "sha256-l4JGodbUmFxHFeEaxgClEozHcbyYP0F2yj5gDqV88IA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
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

  passthru.withProviders = ps: let
    pyEnv = python.withPackages ps;
  in runCommand "octodns-with-providers" { } ''
    mkdir -p $out/bin
    ln -st $out/bin ${pyEnv}/bin/octodns-*
  '';

  meta = with lib; {
    description = "Tools for managing DNS across multiple providers";
    homepage = "https://github.com/octodns/octodns";
    changelog = "https://github.com/octodns/octodns/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ janik ];
  };
}
