{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,

  setuptools,
  setuptools-scm,
  setuptools-rust,
  rustPlatform,
  rustc,
  cargo,
}:

buildPythonPackage (finalAttrs: {
  pname = "slidge-style-parser";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "slidge";
    repo = "style-parser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T3kzi/fnu5bHB13Sn1Yk3VlSxneUORrqiy7Dh3Uxp2w=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-9o9w2ZGYDoEKoG+lnNwT6L7uUxotKOp5h1ViQa0QtfY=";
  };

  build-system = [
    setuptools
    setuptools-scm
    setuptools-rust
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  meta = {
    description = "A parsing library for Slidge";
    homepage = "https://codeberg.org/slidge/style-parser";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ haansn08 ];
  };

})
