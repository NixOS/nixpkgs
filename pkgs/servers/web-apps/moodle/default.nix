{ stdenv, fetchurl, writeText }:

let
  version = "3.8.2";
  stableVersion = builtins.substring 0 2 (builtins.replaceStrings ["."] [""] version);
in

stdenv.mkDerivation rec {
  pname = "moodle";
  inherit version;

  src = fetchurl {
    url = "https://download.moodle.org/stable${stableVersion}/${pname}-${version}.tgz";
    sha256 = "134vxsbslk7sfalmgcp744aygaxz2k080d14j8nkivk9zhplds53";
  };

  phpConfig = writeText "config.php" ''
  <?php
    return require(getenv('MOODLE_CONFIG'));
  ?>
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/moodle
    cp -r . $out/share/moodle
    cp ${phpConfig} $out/share/moodle/config.php

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Free and open-source learning management system (LMS) written in PHP";
    license = licenses.gpl3Plus;
    homepage = "https://moodle.org/";
    maintainers = with maintainers; [ aanderse ];
    platforms = platforms.all;
  };
}
