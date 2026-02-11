{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "tlds";
  version = "2026020700";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kichik";
    repo = "tlds";
    tag = finalAttrs.version;
    hash = "sha256-cpm3x17B+w+Tq+ztQjd0Xttkyivv5Al+3w6RD+SU3T8=";
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
