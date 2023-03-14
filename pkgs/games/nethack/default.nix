{ stdenv, lib, fetchurl, coreutils, ncurses, gzip, flex, bison
, less
, buildPackages
, x11Mode ? false, qtMode ? false, libXaw, libXext, libXpm, bdftopcf, mkfontdir, pkg-config, qt5
}:

let
  platform =
    if stdenv.hostPlatform.isUnix then "unix"
    else throw "Unknown platform for NetHack: ${stdenv.hostPlatform.system}";
  unixHint =
    if x11Mode then "linux-x11"
    else if qtMode then "linux-qt4"
    else if stdenv.hostPlatform.isLinux  then "linux"
    else if stdenv.hostPlatform.isDarwin then "macosx10.10"
    # We probably want something different for Darwin
    else "unix";
  userDir = "~/.config/nethack";
  binPath = lib.makeBinPath [ coreutils less ];

in stdenv.mkDerivation rec {
  version = "3.6.7";
  pname = if x11Mode then "nethack-x11"
         else if qtMode then "nethack-qt"
         else "nethack";

  src = fetchurl {
    url = "https://nethack.org/download/${version}/nethack-${lib.replaceStrings ["."] [""] version}-src.tgz";
    sha256 = "sha256-mM9n323r+WaKYXRaqEwJvKs2Ll0z9blE7FFV1E0qrLI=";
  };

  buildInputs = [ ncurses ]
                ++ lib.optionals x11Mode [ libXaw libXext libXpm ]
                ++ lib.optionals qtMode [ gzip qt5.qtbase.bin qt5.qtmultimedia.bin ];

  nativeBuildInputs = [ flex bison ]
                      ++ lib.optionals x11Mode [ mkfontdir bdftopcf ]
                      ++ lib.optionals qtMode [
                           pkg-config mkfontdir qt5.qtbase.dev
                           qt5.qtmultimedia.dev qt5.wrapQtAppsHook
                           bdftopcf
                         ];

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    sed -e '/^ *cd /d' -i sys/unix/nethack.sh
    sed \
      -e 's/^YACC *=.*/YACC = bison -y/' \
      -e 's/^LEX *=.*/LEX = flex/' \
      -i sys/unix/Makefile.utl
    sed \
      -e 's,^WINQT4LIB =.*,WINQT4LIB = `pkg-config Qt5Gui --libs` \\\
            `pkg-config Qt5Widgets --libs` \\\
            `pkg-config Qt5Multimedia --libs`,' \
      -i sys/unix/Makefile.src
    sed \
      -e 's,^CFLAGS=-g,CFLAGS=,' \
      -e 's,/bin/gzip,${gzip}/bin/gzip,g' \
      -e 's,^WINTTYLIB=.*,WINTTYLIB=-lncurses,' \
      -i sys/unix/hints/linux
    sed \
      -e 's,^CC=.*$,CC=${stdenv.cc.targetPrefix}cc,' \
      -e 's,^HACKDIR=.*$,HACKDIR=\$(PREFIX)/games/lib/\$(GAME)dir,' \
      -e 's,^SHELLDIR=.*$,SHELLDIR=\$(PREFIX)/games,' \
      -e 's,^CFLAGS=-g,CFLAGS=,' \
      -i sys/unix/hints/macosx10.10
    sed -e '/define CHDIR/d' -i include/config.h
    ${lib.optionalString qtMode ''
    sed \
      -e 's,^QTDIR *=.*,QTDIR=${qt5.qtbase.dev},' \
      -e 's,CFLAGS.*QtGui.*,CFLAGS += `pkg-config Qt5Gui --cflags`,' \
      -e 's,CFLAGS+=-DCOMPRESS.*,CFLAGS+=-DCOMPRESS=\\"${gzip}/bin/gzip\\" \\\
        -DCOMPRESS_EXTENSION=\\".gz\\",' \
      -e 's,moc-qt4,moc,' \
      -i sys/unix/hints/linux-qt4
    ''}
    ${lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform)
    # If we're cross-compiling, replace the paths to the data generation tools
    # with the ones from the build platform's nethack package, since we can't
    # run the ones we've built here.
    ''
    ${buildPackages.perl}/bin/perl -p \
      -e 's,[a-z./]+/(makedefs|dgn_comp|lev_comp|dlb)(?!\.),${buildPackages.nethack}/libexec/nethack/\1,g' \
      -i sys/unix/Makefile.*
    ''}
    sed -i -e '/rm -f $(MAKEDEFS)/d' sys/unix/Makefile.src
  '';

  configurePhase = ''
    pushd sys/${platform}
    ${lib.optionalString (platform == "unix") ''
      sh setup.sh hints/${unixHint}
    ''}
    popd
  '';

  enableParallelBuilding = true;

  preFixup = lib.optionalString qtMode ''
    wrapQtApp "$out/games/nethack"
  '';

  postInstall = ''
    mkdir -p $out/games/lib/nethackuserdir
    for i in xlogfile logfile perm record save; do
      mv $out/games/lib/nethackdir/$i $out/games/lib/nethackuserdir
    done

    mkdir -p $out/bin
    cat <<EOF >$out/bin/nethack
    #! ${stdenv.shell} -e
    PATH=${binPath}:\$PATH

    if [ ! -d ${userDir} ]; then
      mkdir -p ${userDir}
      cp -r $out/games/lib/nethackuserdir/* ${userDir}
      chmod -R +w ${userDir}
    fi

    RUNDIR=\$(mktemp -d)

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
    ${lib.optionalString x11Mode "mv $out/bin/nethack $out/bin/nethack-x11"}
    ${lib.optionalString qtMode "mv $out/bin/nethack $out/bin/nethack-qt"}
    install -Dm 555 util/{makedefs,dgn_comp,lev_comp} -t $out/libexec/nethack/
    ${lib.optionalString (!(x11Mode || qtMode)) "install -Dm 555 util/dlb -t $out/libexec/nethack/"}
  '';

  meta = with lib; {
    description = "Rogue-like game";
    homepage = "http://nethack.org/";
    license = "nethack";
    platforms = if x11Mode then platforms.linux else platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
