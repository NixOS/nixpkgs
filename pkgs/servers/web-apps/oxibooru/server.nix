{
  src,
  version,
  lib,
  rustPlatform,
  perl,
  tomlq,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxibooru-server";
  inherit version;

  src = "${src}/server";

  cargoHash = "sha256-BGUPR4imND0/glU7Zm2dFoyCY3JNoH69ytk63SNn1MM=";

  nativeBuildInputs = [
    perl
    tomlq
  ];

  # Test relies on .env
  doCheck = false;

  passthru.tests.oxibooru = nixosTests.oxibooru;

  meta = {
    description = "Server of Oxibooru, an image board engine based on Szurubooru";
    homepage = "https://github.com/rr-/szurubooru";
    license = lib.licenses.gpl3;
    mainProgram = "oxibooru_server";
    maintainers = with lib.maintainers; [ ratcornu ];
  };
})
