{
  stdenvNoCC,
  fetchurl,
  cpio,
  pbzx,
  version,
}:

let
  releases = builtins.fromJSON (builtins.readFile ./apple-sdk-releases.json);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "CLTools_Executables";
  inherit version;

  src = fetchurl releases.${version}.${finalAttrs.pname};

  nativeBuildInputs = [
    cpio
    pbzx
  ];

  buildCommand = ''
    pbzx $src | cpio -idm
    mv Library/Developer/CommandLineTools $out
  '';
})
