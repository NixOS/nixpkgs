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
  version = "12.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolic";
    tag = version;
    # the `py` directory is not included in the tarball, so we fetch the source via git instead
    forceFetchGit = true;
    hash = "sha256-Y24IreRP/YZEugvro8PxMh32qAdEbFWhMxQLfeR1clM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-IUh+6lKGsVqrmbYKEu0kahiQeMGJ3cN5lu1DIj9Hd48=";
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
