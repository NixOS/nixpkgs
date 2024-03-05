{ lib, stdenvNoCC, makeSetupHook, _7zz, libarchive }:

{ pname
, version
, src
, buildInputs ? []
, nativeBuildInputs ? []
, propagatedBuildInputs ? []
, postInstall ? null
, appName ? "."
, sourceRoot ? "."
, ...
}@args:

let
  unpackDmgPkg = makeSetupHook {
    name = "unpack-dmg-pkg";
    propagatedBuildInputs = [ _7zz libarchive ];
  } ./unpack-dmg-pkg.sh;
in
stdenvNoCC.mkDerivation (args // {
  inherit pname appName src buildInputs propagatedBuildInputs postInstall;

  dontMakeSourcesWritable = args.dontMakeSourcesWritable or true;
  dontPatch = args.dontPatch or true;
  dontConfigure = args.dontConfigure or true;
  dontBuild = args.dontBuild or true;
  dontStrip = args.dontStrip or true;
  dontFixup = args.dontFixup or true;
  dontCheck = args.dontCheck or true;
  doInstallCheck = args.doInstallCheck or false;

  sourceRoot = "${pname}/${sourceRoot}";

  nativeBuildInputs = [ unpackDmgPkg ] ++ nativeBuildInputs;

  installPhase = (args.installPhase or ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R "${appName}" $out/Applications

    runHook postInstall
  '');

  installCheckPhase = args.installCheckPhase or null;

  meta = {
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.platforms.darwin;
  } // ( args.meta or {} );
})
