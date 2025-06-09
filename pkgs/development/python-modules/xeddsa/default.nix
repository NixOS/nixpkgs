{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  cffi,
  libsodium,
  libxeddsa,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xeddsa";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "python-xeddsa";
    tag = "v${version}";
    hash = "sha256-636zsJXD8EtLDXMIkJTON0g3sg0EPrMzcfR7SUrURac=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<74" "setuptools"
  '';

  passthru.updateScript = nix-update-script { };

  build-system = [ setuptools ];

  buildInputs = [
    libsodium
    libxeddsa
  ];

  dependencies = [ cffi ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "xeddsa" ];

  meta = {
    description = "Python bindings to libxeddsa";
    homepage = "https://github.com/Syndace/python-xeddsa";
    changelog = "https://github.com/Syndace/python-xeddsa/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ ];
  };
}
