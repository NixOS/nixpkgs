{
  cacert,
  fetchFromGitHub,
  rustPlatform,
  lib,
}:
let
  versioning = lib.importJSON ./versioning.json;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-snowflakes";
  inherit (versioning) version cargoHash;

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (versioning) rev hash;
  };

  buildAndTestSubdir = "fluxer_snowflakes";

  nativeCheckInputs = [
    cacert
  ];

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer-snowflakes";
  };
})
