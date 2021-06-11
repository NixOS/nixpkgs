{ lib, appleDerivation, stdenv, bison, flex }:

let

  # Hard to get CC to pull this off without infinite recursion
  targetTargetPrefix = lib.optionalString
    (with stdenv; hostPlatform != targetPlatform)
    (stdenv.targetPlatform.config + "-");

in

appleDerivation {
  nativeBuildInputs = [ bison flex ];

  buildPhase = ''
    cd migcom.tproj

    # redundant file, don't know why apple not removing it.
    rm handler.c

    yacc -d parser.y
    flex --header-file=lexxer.yy.h -o lexxer.yy.c lexxer.l

    $CC -std=gnu99 -Os -dead_strip -DMIG_VERSION=\"$pname-$version\" -I. -o migcom *.c
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
      --replace 'arch=`/usr/bin/arch`' 'arch=${stdenv.targetPlatform.darwinArch}' \
      --replace '/usr/bin/' "" \
      --replace '/bin/rmdir' "rmdir" \
      --replace 'C=''${MIGCC}' "C=${targetTargetPrefix}cc"
  '';
}
