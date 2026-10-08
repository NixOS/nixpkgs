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
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "python-xeddsa";
    tag = "v${version}";
    hash = "sha256-FHZ9oo9Ps+98dWyPfu3RcmFqZ26zCmO3wNhw+hzuB+w=";
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
