{ fetchurl, stdenv, buildEnv, roundcube, roundcubePlugins }:

stdenv.mkDerivation rec {
  pname = "roundcube";
  version = "1.4.2";

  src = fetchurl {
    url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz";
    sha256 = "0s8gkfnyid1r4xv07vjrbl6558xv6dyn4aapvx8snqdm79n78fn8";
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
