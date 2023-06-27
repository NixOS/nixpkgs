{ lib, stdenv, fetchurl, writeText, nixosTests }:

stdenv.mkDerivation rec {
  pname = "mediawiki";
  version = "1.39.3";

  src = fetchurl {
    url = "https://releases.wikimedia.org/mediawiki/${lib.versions.majorMinor version}/mediawiki-${version}.tar.gz";
    hash = "sha256-41dpNDh2r0JJbaQ64vRyJPuMd5uPRXBcQUfG/zUizB0=";
  };

  postPatch = ''
    sed -i 's|$vars = Installer::getExistingLocalSettings();|$vars = null;|' includes/installer/CliInstaller.php
  '';

  installPhase = let
    phpConfig = writeText "LocalSettings.php" ''
      <?php
        return require(getenv('MEDIAWIKI_CONFIG'));
      ?>
    '';
  in ''
    runHook preInstall

    mkdir -p $out/share/mediawiki
    cp -r * $out/share/mediawiki
    cp ${phpConfig} $out/share/mediawiki/LocalSettings.php

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests.mediawiki) mysql postgresql;
  };

  meta = with lib; {
    description = "The collaborative editing software that runs Wikipedia";
    license = licenses.gpl2Plus;
    homepage = "https://www.mediawiki.org/";
    platforms = platforms.all;
    maintainers = with maintainers; [ ] ++ teams.c3d2.members;
  };
}
