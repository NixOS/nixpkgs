{ fetchurl, lib, stdenv, buildEnv, roundcube, roundcubePlugins }:

stdenv.mkDerivation rec {
  pname = "roundcube";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz";
    sha256 = "sha256-L9x7FmPl6ZcGv/NAk6pHMdS/IqWMtVWiUg7RveeNASw=";
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

  meta = {
    description = "Open Source Webmail Software";
    maintainers = with lib.maintainers; [ vskilet globin ma27 ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
