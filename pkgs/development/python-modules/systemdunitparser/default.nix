{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  wheel,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "systemdunitparser";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sgallagher";
    repo = "systemdunitparser";
    tag = version;
    hash = "sha256-BlOj1rvRfh0SQ7io2N8MsMvAtWvXk0V6hYzlOSrr7hU=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "SystemdUnitParser"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SystemdUnitParser is an extension to Python's configparser.RawConfigParser to properly parse systemd unit files";
    homepage = "https://github.com/sgallagher/systemdunitparser";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ malik ];
  };
}
