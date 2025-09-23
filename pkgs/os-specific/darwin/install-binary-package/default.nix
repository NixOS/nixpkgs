{
  lib,
  stdenvNoCC,
  makeSetupHook,
  _7zz,
  libarchive,
}:

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [
    "appName"
    "sourceRoot"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      appName ? ".",
      nativeBuildInputs ? [ ],
      sourceRoot ? ".",
      ...
    }@attrs:
    let
      unpackDmgPkg = makeSetupHook {
        name = "unpack-dmg-pkg";
        propagatedBuildInputs = [
          _7zz
          libarchive
        ];
      } ./unpack-dmg-pkg.sh;
      hasPhase = args: phase: if args ? "${phase}" then false else true;
    in
    {
      dontMakeSourcesWritable = attrs.dontMakeSourcesWritable or true;
      dontPatch = attrs.dontPatch or hasPhase attrs "patchPhase";
      dontConfigure = attrs.dontConfigure or hasPhase attrs "configurePhase";
      dontBuild = attrs.dontBuild or hasPhase attrs "buildPhase";
      dontStrip = attrs.dontStrip or hasPhase attrs "stringPhase";
      dontFixup = attrs.dontFixup or hasPhase attrs "fixupPhase";
      dontCheck = attrs.dontCheck or hasPhase attrs "checkPhase";
      doInstallCheck = attrs.doInstallCheck or false;

      sourceRoot = if sourceRoot == "" then "" else "${attrs.pname}/${sourceRoot}";

      nativeBuildInputs = [ unpackDmgPkg ] ++ nativeBuildInputs;

      installPhase =
        attrs.installPhase or ''
          runHook preInstall

          mkdir -p $out/Applications
          cp -R "${appName}" $out/Applications \
            || (echo "ERROR: Missing ${appName} directory:"; find . -depth 2 | head -100)

          runHook postInstall
        '';

      installCheckPhase = attrs.installCheckPhase or null;

      meta = {
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        platforms = lib.platforms.darwin;
      }
      // (attrs.meta or { });
    };
}
