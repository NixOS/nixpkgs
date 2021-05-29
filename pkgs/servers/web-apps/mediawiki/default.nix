{ lib, stdenv, fetchurl, makeWrapper, writeText }:

stdenv.mkDerivation rec {
  pname = "mediawiki";
  version = "1.36.0";

  src = with lib; fetchurl {
    url = "https://releases.wikimedia.org/mediawiki/${versions.majorMinor version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-Nc+9zcra+e5gsJdTLFcREhrc4ibT8cO3vR2x4pA83Uo=";
  };

  prePatch = ''
    sed -i 's|$vars = Installer::getExistingLocalSettings();|$vars = null;|' includes/installer/CliInstaller.php
  '';

  phpConfig = writeText "LocalSettings.php" ''
  <?php
    return require(getenv('MEDIAWIKI_CONFIG'));
  ?>
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mediawiki
    cp -r * $out/share/mediawiki
    cp ${phpConfig} $out/share/mediawiki/LocalSettings.php

    runHook postInstall
  '';

  meta = with lib; {
    description = "The collaborative editing software that runs Wikipedia";
    license = licenses.gpl2Plus;
    homepage = "https://www.mediawiki.org/";
    platforms = platforms.all;
    maintainers = [ maintainers.redvers ];
  };
}
