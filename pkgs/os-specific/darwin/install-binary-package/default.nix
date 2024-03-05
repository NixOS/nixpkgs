{
  lib,
  stdenvNoCC,
  makeSetupHook,
  _7zz,
  libarchive,
}:

{
  appName ? ".",
  nativeBuildInputs ? [ ],
  sourceRoot ? ".",
  ...
}@args:

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
stdenvNoCC.mkDerivation (
  args
  // {
    dontMakeSourcesWritable = args.dontMakeSourcesWritable or true;
    dontPatch = args.dontPatch or hasPhase args "patchPhase";
    dontConfigure = args.dontConfigure or hasPhase args "configurePhase";
    dontBuild = args.dontBuild or hasPhase args "buildPhase";
    dontStrip = args.dontStrip or hasPhase args "stringPhase";
    dontFixup = args.dontFixup or hasPhase args "fixupPhase";
    dontCheck = args.dontCheck or hasPhase args "checkPhase";
    doInstallCheck = args.doInstallCheck or false;

    sourceRoot = if sourceRoot == "" then "" else "${args.pname}/${sourceRoot}";

    nativeBuildInputs = [ unpackDmgPkg ] ++ nativeBuildInputs;

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
  }
)
