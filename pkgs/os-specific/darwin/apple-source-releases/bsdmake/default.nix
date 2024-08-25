{ lib, appleDerivation, makeWrapper }:

appleDerivation {
  nativeBuildInputs = [ makeWrapper ];

  patchPhase = ''
    substituteInPlace mk/bsd.prog.mk \
      --replace-fail '-o ''${BINOWN} -g ''${BINGRP}' "" \
      --replace-fail '-o ''${SCRIPTSOWN_''${.ALLSRC:T}}' "" \
      --replace-fail '-g ''${SCRIPTSGRP_''${.ALLSRC:T}}' ""
    substituteInPlace mk/bsd.lib.mk --replace-fail '-o ''${LIBOWN} -g ''${LIBGRP}' ""
    substituteInPlace mk/bsd.info.mk --replace-fail '-o ''${INFOOWN} -g ''${INFOGRP}' ""
    substituteInPlace mk/bsd.doc.mk --replace-fail '-o ''${BINOWN} -g ''${BINGRP}' ""
    substituteInPlace mk/bsd.man.mk --replace-fail '-o ''${MANOWN} -g ''${MANGRP}' ""
    substituteInPlace mk/bsd.files.mk \
      --replace-fail '-o ''${''${group}OWN_''${.ALLSRC:T}}' "" \
      --replace-fail '-g ''${''${group}GRP_''${.ALLSRC:T}}' "" \
      --replace-fail '-o ''${''${group}OWN} -g ''${''${group}GRP}' ""
    substituteInPlace mk/bsd.incs.mk \
      --replace-fail '-o ''${''${group}OWN_''${.ALLSRC:T}}' "" \
      --replace-fail '-g ''${''${group}GRP_''${.ALLSRC:T}}' "" \
      --replace-fail '-o ''${''${group}OWN} -g ''${''${group}GRP}' ""

    # Workaround for https://github.com/NixOS/nixpkgs/issues/103172
    # Prevents bsdmake from failing on systems that already had default limits
    # increased.
    substituteInPlace main.c \
      --replace-fail 'err(2, "setrlimit");' 'warn("setrlimit");'
  '';

  buildPhase = ''
    objs=()
    for file in $(find . -name '*.c'); do
      obj="$(basename "$file" .c).o"
      objs+=("$obj")
      $CC -c "$file" -o "$obj" -DDEFSHELLNAME='"sh"' -D__FBSDID=__RCSID -mdynamic-no-pic -g
    done
    $CC "''${objs[@]}" -o bsdmake
  '';

  installPhase = ''
    install -d 0644 $out/bin
    install -m 0755 bsdmake $out/bin
    install -d 0644 $out/share/mk
    install -m 0755 mk/* $out/share/mk
  '';

  preFixup = ''
    wrapProgram "$out/bin/bsdmake" --add-flags "-m $out/share/mk"
  '';

  meta = {
    platforms = lib.platforms.darwin;
  };
}
