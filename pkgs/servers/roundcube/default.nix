{ lib, stdenv, fetchzip }:
let
  version = "1.3.7";
in
fetchzip rec {
  name= "roundcube-${version}";

  url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz"; 
  sha256 = "0xwqy0adynx7066a0cvz9vyg85waax1i4p70kcdkz7q5jnw4jzhf";
 
  extraPostFetch = ''
    ln -sf /etc/roundcube/config.inc.php $out/config/config.inc.php
    rm -rf $out/installer
  '';

  meta = {
    description = "Open Source Webmail Software";
    maintainers = with stdenv.lib.maintainers; [ vskilet ];
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}

