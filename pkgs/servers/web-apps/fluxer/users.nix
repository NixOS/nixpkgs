{
  cacert,
  fetchFromGitHub,
  rustPlatform,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-users";
  version = "2026.1002.162104";

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    tag = "${finalAttrs.pname}@${finalAttrs.version}";
    hash = "sha256-5e0fVr4DTvvajjB0vaT+1j1XsZ0pQ4FA9ieSca9MqjY=";
  };

  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";
  cargoBuildFlags = [
    "--features"
    "scylla"
  ];
  buildAndTestSubdir = "fluxer_users";

  nativeCheckInputs = [
    cacert
  ];

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer-users";
  };
})
