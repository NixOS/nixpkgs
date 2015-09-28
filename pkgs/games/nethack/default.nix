{ stdenv, fetchurl, writeScript, ncurses, gzip, flex, bison }:

stdenv.mkDerivation rec {
  name = "nethack-3.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/nethack/nethack-343-src.tgz";
    sha256 = "1r3ghqj82j0bar62z3b0lx9hhx33pj7p1ppxr2hg8bgfm79c6fdv";
  };

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ flex bison ];

  preBuild = ''
    ( cd sys/unix ; sh setup.sh )

    sed -e '/define COMPRESS/d' -i include/config.h
    sed -e '1i\#define COMPRESS "${gzip}/bin/gzip"' -i include/config.h
    sed -e '1i\#define COMPRESS_EXTENSION ".gz"' -i include/config.h
    sed -e '/define CHDIR/d' -i include/config.h

    sed -e '/extern char [*]tparm/d' -i win/tty/*.c

    sed -e 's/-ltermlib/-lncurses/' -i src/Makefile
    sed -e 's/^YACC *=.*/YACC = bison -y/' -i util/Makefile
    sed -e 's/^LEX *=.*/LEX = flex/' -i util/Makefile

    sed -re 's@^(CH...).*@\1 = true@' -i Makefile

    sed -e '/^ *cd /d' -i sys/unix/nethack.sh
  '';

  postInstall = ''
    for i in logfile perm record save; do
      rm -rf $out/games/lib/nethackdir/$i
    done

    mkdir -p $out/bin
    cat <<EOF >$out/bin/nethack
      #! ${stdenv.shell} -e
      if [ ! -d ~/.nethack ]; then
        mkdir -p ~/.nethack/save
        for i in logfile perm record; do
          [ ! -e ~/.nethack/\$i ] && touch ~/.nethack/\$i
        done
      fi

      cd ~/.nethack

      cleanup() {
        for i in $out/games/lib/nethackdir/*; do
          rm -rf \$(basename \$i)
        done
      }
      trap cleanup EXIT

      for i in $out/games/lib/nethackdir/*; do
        ln -s \$i \$(basename \$i)
      done
      $out/games/nethack
    EOF
    chmod +x $out/bin/nethack
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Rogue-like game";
    homepage = "http://nethack.org/";
    license = "nethack";
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
