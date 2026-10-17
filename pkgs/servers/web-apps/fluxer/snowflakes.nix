{
  cacert,
  fetchFromGitHub,
  rustPlatform,
  lib,
  fluxerHashes,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-snowflakes";
  inherit (fluxerHashes) version;

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (fluxerHashes) rev hash;
  };

  cargoHash = fluxerHashes.cargo.hash;

  buildAndTestSubdir = "fluxer_snowflakes";

  nativeCheckInputs = [
    cacert
  ];

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer-snowflakes";
  };
})
