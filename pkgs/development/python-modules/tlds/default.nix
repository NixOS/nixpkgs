{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "tlds";
  version = "2025043000";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kichik";
    repo = "tlds";
    tag = version;
    hash = "sha256-yyDnQMQmZAlHvrWgxSi47E26fJ74FI4COwv1NOLvOL0=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "tlds" ];

  # no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Automatically updated list of valid TLDs taken directly from IANA";
    homepage = "https://github.com/kichik/tlds";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
