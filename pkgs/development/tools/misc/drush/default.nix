{ lib, stdenv, fetchurl, fetchFromGitHub, php, which, makeWrapper, bash, coreutils, ncurses }:

stdenv.mkDerivation rec {
  pname = "drush";
  version = "8.4.12";

  src = fetchurl {
    url = "https://github.com/drush-ops/drush/releases/download/${version}/drush.phar";
    sha256 = "sha256-YtD9lD621LJJAM/ieL4KWvY4o4Uqo3+FWgjGYGdQQaw=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -D $src $out/libexec/drush/drush.phar
    makeWrapper ${php}/bin/php $out/bin/drush \
      --add-flags "$out/libexec/drush/drush.phar" \
      --prefix PATH : "${lib.makeBinPath [ which php bash coreutils ncurses ]}"
  '';

  meta = with lib; {
    description = "Command-line shell and Unix scripting interface for Drupal";
    homepage = "https://github.com/drush-ops/drush";
    license = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.all;
  };
}
