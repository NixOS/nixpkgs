{
  lib,
  mkDerivation2,
  fetchFromGitHub,
  nix-update-script,
  ...
}:

mkDerivation2 (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}"; # TODO: construct automatically
  pname = "keypunch";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "bragefuglseth";
    repo = "keypunch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C0WD8vBPlKvCJHVJHSfEbMIxNARoRrCn7PNebJ0rkoI=";
  };

  inherit (finalAttrs.__pkgs.pkgsBuildHost.rustPlatform) fetchCargoTarball cargoSetupHook; # do we care that it's pkgsBuildHost?
  inherit (finalAttrs.__pkgs.pkgsBuildHost)
    cargo
    rustc
    meson
    ninja
    pkg-config
    appstream
    blueprint-compiler
    desktop-file-utils
    gettext
    wrapGAppsHook4
    ;
  inherit (finalAttrs.__pkgs.pkgsHostTarget) libadwaita;

  cargoDeps = finalAttrs.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    hash = "sha256-RufJy5mHuirAO056p5/w63jw5h00E41t+H4VQP3kPks=";
  };

  # new syntax for this would be useful
  nativeBuildInputs = with finalAttrs; [
    # getDev should be used

    cargoSetupHook
    cargo
    rustc

    meson
    ninja

    pkg-config
    appstream
    blueprint-compiler
    desktop-file-utils
    gettext

    wrapGAppsHook4
  ];

  buildInputs = [
    (lib.getDev finalAttrs.libadwaita)
  ];

  shellVars = {
    inherit (finalAttrs)
      src
      cargoDeps
      nativeBuildInputs
      buildInputs
      ;
  };

  # TODO: check if this works or not
  updateScript = nix-update-script { };

  meta = {
    description = "Practice your typing skills";
    homepage = "https://github.com/bragefuglseth/keypunch";
    license = lib.licenses.gpl3Plus;
    mainProgram = "keypunch";
    maintainers = with lib.maintainers; [
      tomasajt
      getchoo
    ];
    platforms = lib.platforms.linux;
  };
})
