{ lib, stdenv, fetchurl, fetchFromGitHub, php, which, makeWrapper, bash, coreutils, ncurses }:

stdenv.mkDerivation rec {
  pname = "drush";
  version = "6.1.0";

  meta = with lib; {
    description = "Command-line shell and Unix scripting interface for Drupal";
    homepage    = "https://github.com/drush-ops/drush";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.all;
  };

  src = fetchFromGitHub {
    owner = "drush-ops";
    repo  = pname;
    rev = version;
    sha256 = "1jgnc4jjyapyn04iczvcz92ic0vq8d1w8xi55ismqyy5cxhqj6bp";
  };

  consoleTable = fetchurl {
    url    = "http://download.pear.php.net/package/Console_Table-1.1.3.tgz";
    sha256 = "07gbjd7m1fj5dmavr0z20vkqwx1cz2522sj9022p257jifj1yl76";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    # install libraries
    cd lib
    tar -xf ${consoleTable}
    cd ..

    mkdir -p "$out"
    cp -r . "$out/src"
    mkdir "$out/bin"
    wrapProgram "$out/src/drush" --prefix PATH : "${lib.makeBinPath [ which php bash coreutils ncurses ]}"
    ln -s "$out/src/drush" "$out/bin/drush"
  '';
}
