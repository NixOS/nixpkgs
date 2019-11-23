{ fetchurl, stdenv, buildEnv, roundcube, roundcubePlugins }:

stdenv.mkDerivation rec {
  pname = "roundcube";
  version = "1.4.0";

  src = fetchurl {
    url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz";
    sha256 = "0b7gc342z0smn7q6cnznj9ncal0515ki4kkq1hlmqmyn0nna5lkb";
  };

  patches = [ ./0001-Don-t-resolve-symlinks-when-trying-to-find-INSTALL_P.patch ];

  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -r * $out/
    ln -sf /etc/roundcube/config.inc.php $out/config/config.inc.php
    rm -rf $out/installer
  '';

  passthru.withPlugins = f: buildEnv {
    name = "${roundcube.name}-with-plugins";
    paths = (f roundcubePlugins) ++ [ roundcube ];
  };

  meta = {
    description = "Open Source Webmail Software";
    maintainers = with stdenv.lib.maintainers; [ vskilet globin ];
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
