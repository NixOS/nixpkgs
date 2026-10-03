{
  cacert,
  fetchFromGitHub,
  rustPlatform,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-snowflakes";
  version = "2026.1001.150225";

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    tag = "${finalAttrs.pname}@${finalAttrs.version}";
    hash = "sha256-zs3T9gWmX7RzzpmumZ4OoNFYIKJc16r0yTujC5t8hY4=";
  };

  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";
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
