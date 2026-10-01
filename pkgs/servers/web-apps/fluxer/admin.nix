{
  rustPlatform,
  fetchFromGitHub,
  tailwindcss_4,
  cacert,
  lib,
}:
let
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-admin";
  version = "2026.930.143634";

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    tag = "${finalAttrs.pname}@${finalAttrs.version}";
    hash = "sha256-88o4InXE0MgnjjaTJchPIsmlmj8/scQZOSC3GqJ++II=";
  };

  nativeBuildInputs = [
    cacert
    tailwindcss_4
  ];

  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

  buildAndTestSubdir = "fluxer_admin";

  # Required for the tests in https://github.com/fluxerapp/fluxer/blob/dfdfffe5de0662eb1fab9b1cc0208748825ff3eb/fluxer_admin/src/templates/components/tooltip.rs
  checkType = "debug";

  # TODO patch build script instead
  preBuild = ''
    mkdir -p node_modules/.bin
    ln -s ${lib.getExe tailwindcss_4} node_modules/.bin/tailwindcss
  '';

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer-admin";
  };
})
