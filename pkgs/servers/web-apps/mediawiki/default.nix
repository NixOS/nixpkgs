{ stdenv, fetchurl, makeWrapper, writeText }:

stdenv.mkDerivation rec {
  pname = "mediawiki";
  version = "1.34.0";

  src = with stdenv.lib; fetchurl {
    url = "https://releases.wikimedia.org/mediawiki/${versions.majorMinor version}/${pname}-${version}.tar.gz";
    sha256 = "1lckjnharwxh9xb7gxdxrkb0r3xgd0dh4019cnbixn5mmzgc696y";
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

  meta = with stdenv.lib; {
    description = "The collaborative editing software that runs Wikipedia";
    license = licenses.gpl2Plus;
    homepage = "https://www.mediawiki.org/";
    platforms = platforms.all;
    maintainers = [ maintainers.redvers ];
  };
}
