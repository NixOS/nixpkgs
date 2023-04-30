{
  cpio,
  fetchurl,
  lib,
  pbzx,
  stdenvNoCC,
  version,
}:
let
  releases = builtins.fromJSON (builtins.readFile ./apple-sdk-releases.json);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit version;
  pname = "CLTools_macOSNMOS_SDK";
  src = fetchurl releases.${version}.${finalAttrs.pname};
  dontBuild = true;
  darwinDontCodeSign = true;
  nativeBuildInputs = [cpio pbzx];
  unpackPhase = ''
    pbzx $src | cpio -idm
  '';
  installPhase = ''
    mv Library/Developer/CommandLineTools/SDKs/MacOSX${lib.versions.majorMinor version}.sdk $out
  '';
})
