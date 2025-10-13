{
  fetchurl,
  lib,
  stdenv,
  buildEnv,
  roundcube,
  roundcubePlugins,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "roundcube";
  version = "1.6.11";

  src = fetchurl {
    url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz";
    sha256 = "sha256-ojDkMgZVVb+ie+o/z0rGcvI1nvKK2E9ZReo8z3AudGY=";
  };

  patches = [ ./0001-Don-t-resolve-symlinks-when-trying-to-find-INSTALL_P.patch ];

  dontBuild = true;

  # FIXME: this should be removed after upstream releases the update forcing the use of public_html.
  dontCheckForBrokenSymlinks = true;

  installPhase = ''
    mkdir $out
    cp -r * $out/
    ln -sf /etc/roundcube/config.inc.php $out/config/config.inc.php
    rm -rf $out/installer
    # shut up updater
    rm $out/composer.json-dist
  '';

  passthru.withPlugins =
    f:
    buildEnv {
      name = "${roundcube.name}-with-plugins";
      paths = (f roundcubePlugins) ++ [ roundcube ];
    };

  passthru.tests = { inherit (nixosTests) roundcube; };

  meta = {
    description = "Open Source Webmail Software";
    maintainers = with lib.maintainers; [
      vskilet
      globin
      ma27
    ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
