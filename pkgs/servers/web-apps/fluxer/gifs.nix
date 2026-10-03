{
  cacert,
  fetchFromGitHub,
  rustPlatform,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-gifs";
  version = "2026.1002.153934";

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    tag = "${finalAttrs.pname}@${finalAttrs.version}";
    hash = "sha256-gIV2AU3uWiP3h31awue6h8A+P38rb5ixqoSUefCJr2k=";
  };

  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";
  buildAndTestSubdir = "fluxer_gifs";

  nativeCheckInputs = [
    cacert
  ];

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer-gifs";
  };
})
