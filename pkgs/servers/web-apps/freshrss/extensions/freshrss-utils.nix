{ stdenv, unzip }:
let
  buildFreshRssExtension =
    args@{
      pname,
      version,
      src,
      FreshRssExtUniqueId,
      configurePhase ? ''
        runHook preConfigure
        runHook postConfigure
      '',
      buildPhase ? ''
        runHook preBuild
        runHook postBuild
      '',
      dontPatchELF ? true,
      dontStrip ? true,
      passthru ? { },
      sourceRoot ? "source",
      ...
    }:
    stdenv.mkDerivation (
      (removeAttrs args [ "FreshRssExtUniqueId" ])
      // {
        pname = "freshrss-extension-${pname}";

        inherit
          version
          src
          configurePhase
          buildPhase
          dontPatchELF
          dontStrip
          sourceRoot
          ;

        installPrefix = "share/freshrss/extensions/xExtension-${FreshRssExtUniqueId}";

        installPhase = ''
          runHook preInstall

          mkdir -p "$out/$installPrefix"
          find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"

          runHook postInstall
        '';

        passthru = passthru // {
          inherit FreshRssExtUniqueId;
        };
      }
    );
in
{
  inherit buildFreshRssExtension;
}
