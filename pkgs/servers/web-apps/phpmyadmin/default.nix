{ pkgs, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "phpmyadmin";
  version = "5.0.4";

  src = fetchurl {
    url = "https://files.phpmyadmin.net/phpMyAdmin/${version}/phpMyAdmin-${version}-all-languages.tar.gz";
    sha256 = "+7mTt0p8Kc4vzba2viKwtsWL/43zKSq0L2KAhxRQwxY=";
  };

  phpConfig = pkgs.writeText "config.php" ''
  <?php
    return require(getenv('PHPMYADMIN_CONFIG'));
  ?>
  '';

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase =
  ''
    mkdir -p $out
    cp -r * $out/

    cp ${phpConfig} $out/config.inc.php
  '';

  meta = with stdenv.lib; {
    description = "A web interface for MySQL and MariaDB";
    license = licenses.gpl2Only;
    homepage = "https://www.phpmyadmin.net/";
    maintainers = with maintainers; [mohe2015];
    platforms = platforms.all;
  };
}
