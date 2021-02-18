{ lib, appleDerivation, yacc, flex }:

appleDerivation {
  nativeBuildInputs = [ yacc flex ];

  buildPhase = ''
    cd migcom.tproj

    # redundant file, don't know why apple not removing it.
    rm handler.c

    yacc -d parser.y
    flex --header-file=lexxer.yy.h -o lexxer.yy.c lexxer.l

    cc -std=gnu99 -Os -dead_strip -DMIG_VERSION=\"$pname-$version\" -I. -o migcom *.c
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
}
