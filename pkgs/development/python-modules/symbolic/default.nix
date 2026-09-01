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

buildPythonPackage (finalAttrs: {
  pname = "symbolic";
  version = "13.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "symbolic";
    tag = finalAttrs.version;
    # the `py` directory is not included in the tarball, so we fetch the source via git instead
    forceFetchGit = true;
    hash = "sha256-o7LqQb+tWpAl+W5sHI51tfd2FEZOpPPgChIpkXjM1D8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-q2+eJufBBzPJEgVqmUagXSU9fQPHQv4jfyCVgHJLBsk=";
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
    changelog = "https://github.com/getsentry/symbolic/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
  };
})
