{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-rust,

  # nativeBuildInputs
  cargo,
  rustPlatform,
  rustc,

  # dependencies
  range-typed-integers,
}:

buildPythonPackage (finalAttrs: {
  pname = "skytemple-rust";
  version = "1.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple-rust";
    tag = finalAttrs.version;
    hash = "sha256-yJ78P00h4SITVuDnIh5IIlWkoed/VtIw3NB8ETB95bk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-9OgUuuMuo2l4YsZMhBZJBqKqbNwj1W4yidoogjcNgm8=";
  };

  env.GETTEXT_SYSTEM = true;

  build-system = [
    setuptools-rust
  ];

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  dependencies = [
    range-typed-integers
  ];

  doCheck = false; # tests for this package are in skytemple-files package
  pythonImportsCheck = [ "skytemple_rust" ];

  meta = {
    description = "Binary Rust extensions for SkyTemple";
    homepage = "https://github.com/SkyTemple/skytemple-rust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
})
