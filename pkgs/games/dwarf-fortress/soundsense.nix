{
  lib,
  stdenv,
  fetchzip,
  dos2unix,
  soundPack ? stdenv.mkDerivation {
    name = "soundsense-soundpack";
    src = fetchzip {
      url = "https://df.zweistein.cz/soundsense/soundpack.zip";
      hash = "sha256-yjlhBLYYv/FXsk5IpiZNDG2ugDldaD5mf+Dyc6es4GM=";
    };
    installPhase = ''
      cp -r . $out
    '';
  },
}:

stdenv.mkDerivation rec {
  version = "2016-1_196";
  dfVersion = "0.44.12";
  inherit soundPack;
  pname = "soundsense";
  src = fetchzip {
    url = "https://df.zweistein.cz/soundsense/soundSense_${version}.zip";
    hash = "sha256-c+LOUxmJaZ3VqVOBYSQypiZxWyNAXOlRQVD3QZPReb4=";
  };
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
  meta = {
    description = "Plays sound based on Dwarf Fortress game logs";
    maintainers = with lib.maintainers; [
      numinit
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    homepage = "https://df.zweistein.cz/soundsense";
  };
}
