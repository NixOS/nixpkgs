{ fetchurl, stdenv, buildEnv, roundcube, roundcubePlugins }:

stdenv.mkDerivation rec {
  pname = "roundcube";
  version = "1.4.7";

  src = fetchurl {
    url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz";
    sha256 = "1jdcda6102n948l6qzhjsiylnmx5fkgjg2hn17g93x3yzwkmvn16";
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
    maintainers = with stdenv.lib.maintainers; [ vskilet globin ma27 ];
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
