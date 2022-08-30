{ lib, stdenv, fetchurl, writeText
, dataPath ? "/var/lib/snappymail" }:
stdenv.mkDerivation rec {
  pname = "snappymail";
  version = "2.17.3";

  src = fetchurl {
    url = "https://github.com/the-djmaze/snappymail/releases/download/v${version}/snappymail-${version}.tar.gz";
    sha256 = "sha256-Ajbii8Amd5ziNNbYccL1nM0Yqbo3xF1XOByAebpEMuk=";
  };

  sourceRoot = "snappymail";

  includeScript = writeText "include.php" ''
    <?php

    # the trailing `/` is important here
    define('APP_DATA_FOLDER_PATH', '${dataPath}/');
  '';

  installPhase = ''
    mkdir $out
    cp -r ../* $out
    rm -rf $out/{data,env-vars,_include.php}
    cp ${includeScript} $out/include.php
  '';

  meta = with lib; {
    description = "Simple, modern & fast web-based email client";

    homepage = "https://snappymail.eu";
    downloadPage = "https://github.com/the-djmaze/snappymail/releases";
    license = licenses.agpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ mic92 ];
  };
}
