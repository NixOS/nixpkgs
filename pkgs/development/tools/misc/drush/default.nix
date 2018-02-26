{ stdenv, fetchurl, php, which, makeWrapper, bash, coreutils, ncurses }:

stdenv.mkDerivation rec {
  name = "drush-8.1.16";

  meta = with stdenv.lib; {
    description = "Command-line shell and Unix scripting interface for Drupal";
    homepage    = https://github.com/drush-ops/drush;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.all;
  };

  src = fetchurl {
    url    = https://github.com/drush-ops/drush/archive/8.1.16.tar.gz;
    sha256 = "0k8b57dq7arw102mbmws2q6f9bz4pmnba768n5qbfqw1r92yligi";
  };

  consoleTable = fetchurl {
    url    = http://download.pear.php.net/package/Console_Table-1.1.3.tgz;
    sha256 = "07gbjd7m1fj5dmavr0z20vkqwx1cz2522sj9022p257jifj1yl76";
  };

  buildInputs = [ php which makeWrapper ];

  installPhase = ''
    # install libraries
    cd lib
    tar -xf ${consoleTable}
    cd ..

    mkdir -p "$out"
    cp -r . "$out/src"
    mkdir "$out/bin"
    wrapProgram "$out/src/drush" --prefix PATH : "${stdenv.lib.makeBinPath [ which php bash coreutils ncurses ]}"
    ln -s "$out/src/drush" "$out/bin/drush"
  '';
}
