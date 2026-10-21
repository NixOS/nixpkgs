{
  cacert,
  fetchFromGitHub,
  rustPlatform,
  lib,
  fluxerHashes,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-messages";
  inherit (fluxerHashes) version;

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (fluxerHashes) rev hash;
  };

  cargoHash = fluxerHashes.cargo.hash;

  buildFeatures = [ "scylla" ];
  buildAndTestSubdir = "fluxer_messages";
  checkType = "debug"; # because of fluxer_svc/src/transport.rs:533:20

  nativeCheckInputs = [
    cacert
  ];

  meta = {
    description = "Message storage service for Fluxer, a free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer-messages";
  };
})
