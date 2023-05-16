{ fetchurl, lib, stdenv, buildEnv, roundcube, roundcubePlugins }:

stdenv.mkDerivation rec {
  pname = "roundcube";
<<<<<<< HEAD
  version = "1.6.2";

  src = fetchurl {
    url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz";
    sha256 = "sha256-yJgwfZXMSEGM+VUX71K1sAiMUAFPZ6bvgVdjQoqAQ/A=";
=======
  version = "1.6.1";

  src = fetchurl {
    url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz";
    sha256 = "sha256-RsL2ujS8t+V+R8sDS/M45fx9zO3dqSEqLvO9MUbZe+0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
