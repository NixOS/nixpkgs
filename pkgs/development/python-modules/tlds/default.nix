{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "tlds";
  version = "2026102900";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kichik";
    repo = "tlds";
    tag = finalAttrs.version;
    hash = "sha256-n6pY/Qx7/lyqIgq5L4z3aENVk2x1wFHc2uMv5rr03wk=";
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
