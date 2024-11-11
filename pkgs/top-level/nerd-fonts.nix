{
  lib,
  stdenvNoCC,
  newScope,
}:

lib.makeScope newScope (
  self:
  let
    makeNerdFont =
      args:
      let
        passthruAttributes = [
          "dirName"
          "originalName"
          "declaresRFN"
          "originalDescription"
          "originalLicense"
          "releaseVersion"
        ];
        args' = builtins.removeAttrs args passthruAttributes;
      in
      stdenvNoCC.mkDerivation (
        lib.recursiveUpdate {
          dontConfigure = true;
          dontBuild = true;
          installPhase = ''
            runHook preInstall

            dst_opentype=$out/share/fonts/opentype/NerdFonts/${args.dirName}
            dst_truetype=$out/share/fonts/truetype/NerdFonts/${args.dirName}
            find -name \*.otf -exec mkdir -p $dst_opentype \; -exec cp -p {} $dst_opentype \;
            find -name \*.ttf -exec mkdir -p $dst_truetype \; -exec cp -p {} $dst_truetype \;

            runHook postInstall
          '';
          dontFixup = true;

          passthru = {
            updateScript = [
              ../data/fonts/nerd-fonts/update-specific-font.sh
              # Helps specifying exactly which font are we updating - based on
              # upstream's fonts.json file.
              args.dirName
            ];
            # TODO: Inherit passthruAttributes of args here
          };

          meta = {
            # description should be specified manually per font, as upstream's
            # description (available here in args.originalDescription), doesn't
            # fit our meta.description guidelines.
            #
            # License as well should be specified using the licenses in
            # lib.licenses.
            homepage = "https://nerdfonts.com/";
            changelog = "https://github.com/ryanoasis/nerd-fonts/blob/v${args.releaseVersion}/changelog.md";
            platforms = lib.platforms.all;
            maintainers = with lib.maintainers; [
              doronbehar
              rc-zb
            ];
          };
        } args'
      );
    callPackage = self.newScope {
      inherit makeNerdFont;
    };
  in
  lib.pipe ../data/fonts/nerd-fonts [
    builtins.readDir
    # Take only Nix files
    (lib.filterAttrs (n: v: ((v == "regular") && (lib.hasSuffix ".nix" n))))
    # Take the file names
    builtins.attrNames
    # Remove .nix suffix to get attribute names
    (map (fName: lib.removeSuffix ".nix" fName))
    (
      attributes:
      lib.genAttrs attributes (a: callPackage (../data/fonts/nerd-fonts + ("/" + a + ".nix")) { })
    )
  ]
)
