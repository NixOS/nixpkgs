{
  lib,
  stdenvNoCC,
}:

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [
    "appName"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      appName ? ".",
      nativeBuildInputs ? [ ],
      ...
    }@args:
    let
      hasPhase = args: phase: if args ? "${phase}" then false else true;
    in
    {
      dontMakeSourcesWritable = args.dontMakeSourcesWritable or true;
      dontPatch = args.dontPatch or hasPhase args "patchPhase";
      dontConfigure = args.dontConfigure or hasPhase args "configurePhase";
      dontBuild = args.dontBuild or hasPhase args "buildPhase";
      dontStrip = args.dontStrip or hasPhase args "stringPhase";
      dontFixup = args.dontFixup or hasPhase args "fixupPhase";
      dontCheck = args.dontCheck or hasPhase args "checkPhase";
      doInstallCheck = args.doInstallCheck or false;

      installPhase =
        args.installPhase or ''
          runHook preInstall

          mkdir -p $out/Applications
          cp -R "${appName}" $out/Applications \
            || (echo "ERROR: Missing ${appName} directory:"; find . -depth 2 | head -100)

          runHook postInstall
        '';

      installCheckPhase = args.installCheckPhase or null;

      meta = {
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        platforms = lib.platforms.darwin;
      }
      // (args.meta or { });
    };
}
