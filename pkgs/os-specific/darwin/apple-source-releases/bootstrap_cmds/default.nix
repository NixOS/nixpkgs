{ stdenv, appleDerivation, yacc, flex }:

appleDerivation {
  nativeBuildInputs = [ yacc flex ];

  buildPhase = ''
    cd migcom.tproj
    yacc -d parser.y
    flex --header-file=lexxer.yy.h -o lexxer.yy.c lexxer.l

    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o error.o error.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o global.o global.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o handler.o header.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o header.o header.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o mig.o mig.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o routine.o routine.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o server.o server.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o statement.o statement.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o string.o string.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o type.o type.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o user.o user.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o utils.o utils.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o lexxer.yy.o lexxer.yy.c
    cc -Os -pipe -DMIG_VERSION="" -Wall -mdynamic-no-pic -I. -c -o y.tab.o y.tab.c

    cc -dead_strip -o migcom error.o global.o header.o mig.o routine.o server.o statement.o string.o type.o user.o utils.o lexxer.yy.o y.tab.o
  '';

  installPhase = ''
    mkdir -p $out/bin $out/libexec $out/share/man/man1

    chmod +x mig.sh
    cp mig.sh   $out/bin/mig
    cp migcom   $out/libexec
    ln -s $out/libexec/migcom $out/bin/migcom
    cp mig.1    $out/share/man/man1
    cp migcom.1 $out/share/man/man1

    substituteInPlace $out/bin/mig \
      --replace 'arch=`/usr/bin/arch`' 'arch=i386' \
      --replace '/usr/bin/' "" \
      --replace '/bin/rmdir' "rmdir" \
      --replace 'C=''${MIGCC}' "C=cc"
  '';

  meta = {
    platforms = stdenv.lib.platforms.darwin;
  };
}
