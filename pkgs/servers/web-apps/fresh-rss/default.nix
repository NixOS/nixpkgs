{ stdenv, fetchFromGitHub, writeText }:

stdenv.mkDerivation rec {
  pname = "fresh-rss";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "FreshRSS";
    repo = "FreshRSS";
    rev = version;
    sha256 = "0xnflvqhifk0icqqclv4qbs43x77syi3szha5mzqxf2fxyzrs358";
  };

  phpConfig = writeText "constants.local.php" ''
  <?php
    safe_define('DATA_PATH', '/var/lib/fresh-rss');
  ?>
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fresh-rss
    cp -r . $out/share/fresh-rss
    cp ${phpConfig} $out/share/fresh-rss/constants.local.php

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A free, self-hostable aggregator... probably the best!";
    license = licenses.agpl3;
    homepage = "https://freshrss.org/";

    platforms = platforms.all;
  };
}
