{ fetchurl, lib, stdenv, buildEnv, roundcube, roundcubePlugins, nixosTests }:

stdenv.mkDerivation rec {
  pname = "roundcube";
  version = "1.6.8";

  src = fetchurl {
    url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz";
    sha256 = "sha256-hGi+AgSnNMV0re9L4BV4x9xPq5wv40ADvzQaK9IO/So=";
  };

  patches = [ ./0001-Don-t-resolve-symlinks-when-trying-to-find-INSTALL_P.patch ];

  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -r * $out/
    ln -sf /etc/roundcube/config.inc.php $out/config/config.inc.php
    rm -rf $out/installer
    # shut up updater
    rm $out/composer.json-dist
  '';

  passthru.withPlugins = f: buildEnv {
    name = "${roundcube.name}-with-plugins";
    paths = (f roundcubePlugins) ++ [ roundcube ];
  };

  passthru.tests = { inherit (nixosTests) roundcube; };

  meta = {
    description = "Open Source Webmail Software";
    maintainers = with lib.maintainers; [ vskilet globin ma27 ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
