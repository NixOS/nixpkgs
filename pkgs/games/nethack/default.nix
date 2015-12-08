{ stdenv, lib, fetchurl, writeScript, ncurses, gzip, flex, bison }:

let
  platform =
    if lib.elem stdenv.system lib.platforms.unix then "unix"
    else abort "Unknown platform for NetHack";
  unixHint =
    if stdenv.isLinux then "linux"
    # We probably want something different for Darwin
    else "unix";
  userDir = "~/.config/nethack";

in stdenv.mkDerivation {
  name = "nethack-3.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/nethack/nethack-360-src.tgz";
    sha256 = "12mi5kgqw3q029y57pkg3gnp930p7yvlqi118xxdif2qhj6nkphs";
  };

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ flex bison ];

  makeFlags = [ "PREFIX=$(out)" ];

  configurePhase = ''
    cd sys/${platform}
    ${lib.optionalString (platform == "unix") ''
      sed -e '/^ *cd /d' -i nethack.sh
      ${lib.optionalString (unixHint == "linux") ''
        sed \
          -e 's,/bin/gzip,${gzip}/bin/gzip,g' \
          -e 's,^WINTTYLIB=.*,WINTTYLIB=-lncurses,' \
          -i hints/linux
      ''}
      sh setup.sh hints/${unixHint}
    ''}
    cd ../..

    sed -e '/define CHDIR/d' -i include/config.h
    sed \
      -e 's/^YACC *=.*/YACC = bison -y/' \
      -e 's/^LEX *=.*/LEX = flex/' \
      -i util/Makefile
  '';

  postInstall = ''
    mkdir -p $out/games/lib/nethackuserdir
    for i in logfile perm record save; do
      mv $out/games/lib/nethackdir/$i $out/games/lib/nethackuserdir
    done

    mkdir -p $out/bin
    cat <<EOF >$out/bin/nethack
    #! ${stdenv.shell} -e

    if [ ! -d ${userDir} ]; then
      mkdir -p ${userDir}
      cp -r $out/games/lib/nethackuserdir/* ${userDir}
      chmod -R +w ${userDir}
    fi

    RUNDIR=\$(mktemp -td nethack.\$USER.XXXXX)

    cleanup() {
      rm -rf \$RUNDIR
    }
    trap cleanup EXIT

    cd \$RUNDIR
    for i in ${userDir}/*; do
      ln -s \$i \$(basename \$i)
    done
    for i in $out/games/lib/nethackdir/*; do
      ln -s \$i \$(basename \$i)
    done
    $out/games/nethack
    EOF
    chmod +x $out/bin/nethack
  '';

  meta = with stdenv.lib; {
    description = "Rogue-like game";
    homepage = "http://nethack.org/";
    license = "nethack";
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
