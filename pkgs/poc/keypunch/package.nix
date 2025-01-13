{
  lib,
  mkPackage,
  ...
}:

mkPackage (
  { layer0Attrs, layer3Attrs, ... }:

  let
    inherit (layer0Attrs.__pkgs) pkgsBuildHost pkgsHostTarget;
  in
  {
    pname = "keypunch";
    version = "5.1";

    src = pkgsHostTarget.fetchFromGitHub {
      owner = "bragefuglseth";
      repo = "keypunch";
      tag = "v${layer0Attrs.version}";
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
      inherit (layer0Attrs) pname version src;
      hash = "sha256-RufJy5mHuirAO056p5/w63jw5h00E41t+H4VQP3kPks=";
    };

    nativeBuildInputs = lib.attrValues layer0Attrs.depsInPath;

    buildInputs = map lib.getDev (lib.attrValues layer0Attrs.deps);

    lay3 = layer0Attrs.layer3Attrs;

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
