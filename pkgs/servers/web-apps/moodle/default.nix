{ stdenv, fetchurl, writeText }:

let
  version = "3.9";
  stableVersion = builtins.substring 0 2 (builtins.replaceStrings ["."] [""] version);
in

stdenv.mkDerivation rec {
  pname = "moodle";
  inherit version;

  src = fetchurl {
    url = "https://download.moodle.org/stable${stableVersion}/${pname}-${version}.tgz";
    sha256 = "1splsxdxzwf49zxrdb4q05fj60agqyzv0ikvk05gaf49qqd8rznz";
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
