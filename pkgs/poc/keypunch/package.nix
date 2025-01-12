{
  lib,
  mkPackage,
  ...
}:

mkPackage (
  finalAttrs:

  let
    inherit (finalAttrs.finalLayer1Attrs.__pkgs) pkgsBuildHost pkgsHostTarget;
  in
  {
    pname = "keypunch";
    version = "5.1";

    src = pkgsHostTarget.fetchFromGitHub {
      owner = "bragefuglseth";
      repo = "keypunch";
      tag = "v${finalAttrs.version}";
      hash = "sha256-C0WD8vBPlKvCJHVJHSfEbMIxNARoRrCn7PNebJ0rkoI=";
    };

    depsInPath = {
      inherit (pkgsBuildHost.rustPlatform) cargoSetupHook; # do we care that it's pkgsBuildHost?
      inherit (pkgsBuildHost)
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
    };

    deps = {
      inherit (pkgsHostTarget) libadwaita;
    };

    # we use the value directly, so it's not overridable
    cargoDeps = pkgsHostTarget.rustPlatform.fetchCargoTarball {
      inherit (finalAttrs) pname version src;
      hash = "sha256-RufJy5mHuirAO056p5/w63jw5h00E41t+H4VQP3kPks=";
    };

    nativeBuildInputs = lib.attrValues finalAttrs.depsInPath;

    buildInputs = map lib.getDev (lib.attrValues finalAttrs.deps);

    shellVars = {
      inherit (finalAttrs)
        src
        cargoDeps
        nativeBuildInputs
        buildInputs
        ;
    };

    lay3 = finalAttrs.finalLayer3Attrs;

    # TODO: check if this works or not
    updateScript = pkgsBuildHost.nix-update-script { };

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
  }
)
