{
  fetchurl,
  lib,
  stdenv,
  buildEnv,
  roundcube,
  roundcubePlugins,
  nixosTests,
  runCommand,
}:

stdenv.mkDerivation rec {
  pname = "roundcube";
  version = "1.7.0";

  src = fetchurl {
    url = "https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz";
    sha256 = "sha256-o0w2baK3okrUpjgrS7mmd8tYHuCL/GME0KmnIQmOepg=";
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
  '';

  passthru.withPlugins =
    f:
    buildEnv {
      name = "${roundcube.name}-with-plugins";
      paths = (f roundcubePlugins) ++ [
        roundcube
        (runCommand "dummy" { } ''
          mkdir -p $out/public_html/
        '')
      ];
    };

  passthru.tests = { inherit (nixosTests) roundcube; };

  meta = {
    description = "Open Source Webmail Software";
    maintainers = with lib.maintainers; [
      vskilet
      ma27
    ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
