{ stdenvNoCC, lib, fetchurl, undmg, version, sha256, isArm }:

let
  pname = "beekeeper-studio";
  name = "${pname}-${version}";
  appName = "Beekeeper\\ Studio.app";

  armPostfix = if isArm then "-arm64" else "";

  src = fetchurl {
    inherit sha256;
    url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${version}/Beekeeper-Studio-${version}${armPostfix}.dmg";
    name = "${pname}-${version}.dmg";
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    undmg ${src}
  '';

  installPhase = ''
    set -x
    mkdir -p $out/Applications/
    #echo COPYING DATA TO $out
    cp -R . $out/Applications/
    set +x
  '';

  meta.platforms = lib.platforms.darwin;
}
