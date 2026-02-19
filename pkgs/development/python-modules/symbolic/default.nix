{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-rust,
  rustPlatform,
  rustc,
  cargo,
  milksnake,
  cffi,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "symbolic";
  version = "12.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolic";
    tag = version;
    # the `py` directory is not included in the tarball, so we fetch the source via git instead
    forceFetchGit = true;
    hash = "sha256-Rcijs9yq+WzzADxq0SKcL99jvquZTVb2dPs+qUB7zJc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-yTSBWs7wN+XGh687LSryJ1d55ZTV5GbojwPyQ+JXKNI=";
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    rustc
    cargo
    milksnake
  ];

  dependencies = [ cffi ];

  preBuild = ''
    cd py
  '';

  preCheck = ''
    cd ..
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "py" ];

  pythonImportsCheck = [ "symbolic" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for dealing with symbol files and more";
    homepage = "https://github.com/getsentry/symbolic";
    changelog = "https://github.com/getsentry/symbolic/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
