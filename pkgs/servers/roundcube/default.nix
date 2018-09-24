{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name= "roundcube-${version}";
  version = "1.3.7";

  src = fetchurl {
    url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz"; 
    sha256 = "31bd37d0f89dc634064f170c6ed8981c258754b6f81eccb59a2634b29d0bb01c";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
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

