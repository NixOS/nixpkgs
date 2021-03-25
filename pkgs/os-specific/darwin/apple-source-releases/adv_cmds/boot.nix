{ lib, appleDerivation, fetchzip, bsdmake, perl, flex, yacc
}:

# this derivation sucks
# locale data was removed after adv_cmds-118, so our base is that because it's easier than
# replicating the bizarre bsdmake file structure
#
# sadly adv_cmds-118 builds a mklocale and colldef that generate files that our libc can no
# longer understand
#
# the more recent adv_cmds release is used for everything else in this package

let recentAdvCmds = fetchzip {
  url = "https://opensource.apple.com/tarballs/adv_cmds/adv_cmds-158.tar.gz";
  sha256 = "0z081kcprzg5jcvqivfnwvvv6wfxzkjg2jc2lagsf8c7j7vgm8nn";
};

in appleDerivation {
  nativeBuildInputs = [ bsdmake perl yacc flex ];
  buildInputs = [ flex ];

  patchPhase = ''
    substituteInPlace BSDmakefile \
      --replace chgrp true \
      --replace /Developer/Makefiles/bin/compress-man-pages.pl true \
      --replace "ps.tproj" "" --replace "gencat.tproj" "" --replace "md.tproj" "" \
      --replace "tabs.tproj" "" --replace "cap_mkdb.tproj" "" \
      --replace "!= tconf --test TARGET_OS_EMBEDDED" "= NO"

    substituteInPlace Makefile --replace perl true

    for subproject in colldef mklocale monetdef msgdef numericdef timedef; do
      substituteInPlace usr-share-locale.tproj/$subproject/BSDmakefile \
        --replace /usr/share/locale "" \
        --replace '-o ''${BINOWN} -g ''${BINGRP}' "" \
        --replace "rsync -a" "cp -r"
    done
  '';

  preBuild = ''
    cp -r --no-preserve=all ${recentAdvCmds}/colldef .
    pushd colldef
    mv locale/collate.h .
    flex -t -8 -i scan.l > scan.c
    yacc -d parse.y
    clang *.c -o colldef -lfl
    popd
    mv colldef/colldef colldef.tproj/colldef

    cp -r --no-preserve=all ${recentAdvCmds}/mklocale .
    pushd mklocale
    flex -t -8 -i lex.l > lex.c
    yacc -d yacc.y
    clang *.c -o mklocale -lfl
    popd
    mv mklocale/mklocale mklocale.tproj/mklocale
  '';

  buildPhase = ''
    runHook preBuild

    bsdmake -C usr-share-locale.tproj

    clang ${recentAdvCmds}/ps/*.c -o ps
  '';

  installPhase = ''
    bsdmake -C usr-share-locale.tproj install DESTDIR="$locale/share/locale"

    # need to get rid of runtime dependency on flex
    # install -d 0755 $locale/bin
    # install -m 0755 colldef.tproj/colldef $locale/bin
    # install -m 0755 mklocale.tproj/mklocale $locale/bin

    install -d 0755 $ps/bin
    install ps $ps/bin/ps
    touch "$out"
  '';

  outputs = [
    "out"
    "ps"
    "locale"
  ];
  setOutputFlags = false;

  meta = {
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ gridaphobe ];
  };
}
