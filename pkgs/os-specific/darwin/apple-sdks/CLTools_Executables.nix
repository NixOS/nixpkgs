{
  cpio,
  fetchurl,
  pbzx,
  stdenvNoCC,
  version,
}: let
  releases = builtins.fromJSON (builtins.readFile ./apple-sdk-releases.json);
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    inherit version;
    pname = "CLTools_Executables";
    src = fetchurl releases.${version}.${finalAttrs.pname};
    dontBuild = true;
    darwinDontCodeSign = true;
    nativeBuildInputs = [cpio pbzx];
    unpackPhase = ''
      pbzx $src | cpio -idm
    '';
    installPhase = ''
      mv Library/Developer/CommandLineTools $out
    '';
  })
