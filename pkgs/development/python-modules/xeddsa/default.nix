{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  cffi,
  libsodium,
  libxeddsa,
  pytestCheckHook,
  pytest-cov-stub,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xeddsa";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "python-xeddsa";
    tag = "v${version}";
    hash = "sha256-5s6ERazWnwYEc0d5e+eSdvOCTklBQVrjzvlNifC2zKU=";
  };

  passthru.updateScript = nix-update-script { };

  build-system = [ setuptools ];

  buildInputs = [
    libsodium
    libxeddsa
  ];

  dependencies = [ cffi ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "xeddsa" ];

  meta = {
    description = "Python bindings to libxeddsa";
    homepage = "https://github.com/Syndace/python-xeddsa";
    changelog = "https://github.com/Syndace/python-xeddsa/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = [ ];
  };
}
