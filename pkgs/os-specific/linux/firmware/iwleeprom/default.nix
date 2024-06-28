{
  stdenv,
  pkgs,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  name = "iwleeprom";
  version = "unstable-2024-05-02";
  src = fetchFromGitHub {
    owner = "abajk";
    repo = "iwleeprom";
    rev = "1030c95fbeb1fa5f45db1c2b96f2e93a3ce1c1a0";
    sha256 = "sha256-3U+VdVXqA/261zB6rKGU1ZivYzjl1ri8NqFnU3di8+A=";
  };

  nativeBuildInputs = with pkgs; [ gzip ];

  buildPhase = ''
    mkdir obj
    $CC -Wall  -c -o obj/iwlio.o iwlio.c
    $CC -Wall  -c -o obj/ath5kio.o ath5kio.c
    $CC -Wall  -c -o obj/ath9kio.o ath9kio.c
    $CC -Wall  -c -o obj/iwleeprom.o iwleeprom.c
    $CC -Wall  -o iwleeprom obj/iwleeprom.o obj/iwlio.o obj/ath5kio.o obj/ath9kio.o
    rm -r obj
    gzip -c iwleeprom.8 > iwleeprom.8.gz
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man8
    install -m 755 iwleeprom $out/bin
    install -m 644 iwleeprom.8.gz $out/share/man/man8
  '';

  meta = with lib; {
    description = "EEPROM reader/writer for Intel and Atheros wifi cards";
    longDescription = "EEPROM reader/writer for Intel (iwlio) and Atheros (ath5k, ath9k) wifi cards. May require iomem=relaxed";
    homepage = "https://code.google.com/archive/p/iwleeprom/";
    changelog = "https://code.google.com/archive/p/iwleeprom/source/default/commits";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
