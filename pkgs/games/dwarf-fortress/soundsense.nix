{ stdenv, fetchzip, dos2unix
, soundPack ? stdenv.mkDerivation {
    name = "soundsense-soundpack";
    src = fetchzip {
      url = "http://df.zweistein.cz/soundsense/soundpack.zip";
      sha256 = "0qz0mjkp7wp0gxk3ws2x760awv8c9lkacj2fn9bz3gqqnq262ffa";
    };
    installPhase = ''
      cp -r . $out
    '';
}}:

stdenv.mkDerivation rec {
  version = "2016-1_196";
  dfVersion = "0.44.02";
  inherit soundPack;
  name = "soundsense-${version}";
  src = fetchzip {
    url = "http://df.zweistein.cz/soundsense/soundSense_${version}.zip";
    sha256 = "1gkrs69l3xsh858yjp204ddp29m668j630akm7arssc9359wxqkk";
  };
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];
  nativeBuildInputs = [ dos2unix ];
  buildPhase = ''
    dos2unix soundSense.sh
    chmod +x soundSense.sh
  '';
  installPhase = ''
    mkdir $out
    cp -R . $out/soundsense
    ln -s $out/soundsense/dfhack $out/hack
    ln -s $soundPack $out/soundsense/packs
  '';
  passthru = { inherit version dfVersion; };
}
