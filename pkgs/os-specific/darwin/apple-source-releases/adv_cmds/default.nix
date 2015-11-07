{ stdenv, appleDerivation, fetchzip, version, bsdmake, perl, flex, yacc, writeScriptBin
}:

let recentAdvCmds = fetchzip {
  url = "http://opensource.apple.com/tarballs/adv_cmds/adv_cmds-158.tar.gz";
  sha256 = "0z081kcprzg5jcvqivfnwvvv6wfxzkjg2jc2lagsf8c7j7vgm8nn";
};

in appleDerivation {
  buildInputs = [ bsdmake perl yacc flex (writeScriptBin "lex" "exec ${flex}/bin/flex $@") ];

  patchPhase = ''
    substituteInPlace BSDMakefile \
      --replace chgrp true \
      --replace /Developer/Makefiles/bin/compress-man-pages.pl true \
      --replace "ps.tproj" "" --replace "gencat.tproj" "" --replace "md.tproj" "" \
      --replace "tabs.tproj" "" --replace "cap_mkdb.tproj" "" \
      --replace "!= tconf --test TARGET_OS_EMBEDDED" "= NO"

    substituteInPlace Makefile --replace perl true

    substituteInPlace colldef.tproj/BSDmakefile --replace "-ll" "-lfl"

    for subproject in colldef mklocale monetdef msgdef numericdef timedef; do
      substituteInPlace usr-share-locale.tproj/$subproject/BSDmakefile \
        --replace /usr/share/locale "" \
        --replace '-o ''${BINOWN} -g ''${BINGRP}' "" \
        --replace "rsync -a" "cp -r"
    done
  '';

  buildPhase = ''
    bsdmake -C colldef.tproj
    bsdmake -C mklocale.tproj
    bsdmake -C usr-share-locale.tproj

    clang ${recentAdvCmds}/ps/*.c -o ps
  '';

  installPhase = ''
    bsdmake -C usr-share-locale.tproj install DESTDIR="$locale/share/locale"
    install -d 0755 $ps/bin
    install ps $ps/bin/ps
  '';

  outputs = [
    "ps"
    "locale"
  ];

  # ps uses this syscall to get process info
  __propagatedSandboxProfile = stdenv.lib.sandbox.allow "mach-priv-task-port";

  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ gridaphobe ];
  };
}
