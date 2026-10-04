{
  rustPlatform,
  fetchFromGitHub,
  tailwindcss_4,
  cacert,
  lib,
}:
let
  versioning = lib.importJSON ./versioning.json;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluxer-admin";
  inherit (versioning) version cargoHash;

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (versioning) rev hash;
  };

  nativeBuildInputs = [
    tailwindcss_4
  ];

  nativeCheckInputs = [
    cacert
  ];

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
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer_admin";
  };
})
