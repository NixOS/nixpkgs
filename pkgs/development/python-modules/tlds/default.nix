{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "tlds";
  version = "2026112100";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kichik";
    repo = "tlds";
    tag = finalAttrs.version;
    hash = "sha256-uL8e8qRxc37anAeciICVTGgQp5Uz+CI9Kbo+AyUAXCg=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "tlds" ];

  # no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatically updated list of valid TLDs taken directly from IANA";
    homepage = "https://github.com/kichik/tlds";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
