{ lib
, derivationWithMeta
, kaem-unwrapped
, M1
, M2
, blood-elf-0
, hex2
, m2libc
, src
, version
}:

let
  ARCH = "x86";
  BLOOD_FLAG = " ";
  BASE_ADDRESS = "0x8048000";
  ENDIAN_FLAG = "--little-endian";

  # We need a few tools from mescc-tools-extra to assemble the output folder
  buildMesccToolsExtraUtil = name:
    derivationWithMeta {
      pname = "mescc-tools-extra-${name}";
      builder = kaem-unwrapped;
      args = [
        "--verbose"
        "--strict"
        "--file"
        (builtins.toFile "build-${name}.kaem" ''
          ''${M2} --architecture ''${ARCH} \
            -f ''${m2libc}/sys/types.h \
            -f ''${m2libc}/stddef.h \
            -f ''${m2libc}/''${ARCH}/linux/fcntl.c \
            -f ''${m2libc}/fcntl.c \
            -f ''${m2libc}/''${ARCH}/linux/unistd.c \
            -f ''${m2libc}/''${ARCH}/linux/sys/stat.c \
            -f ''${m2libc}/stdlib.c \
            -f ''${m2libc}/stdio.h \
            -f ''${m2libc}/stdio.c \
            -f ''${m2libc}/string.c \
            -f ''${m2libc}/bootstrappable.c \
            -f ''${src}/mescc-tools-extra/${name}.c \
            --debug \
            -o ${name}.M1

          ''${blood-elf-0} ''${ENDIAN_FLAG} -f ${name}.M1 -o ${name}-footer.M1

          ''${M1} --architecture ''${ARCH} \
            ''${ENDIAN_FLAG} \
            -f ''${m2libc}/''${ARCH}/''${ARCH}_defs.M1 \
            -f ''${m2libc}/''${ARCH}/libc-full.M1 \
            -f ${name}.M1 \
            -f ${name}-footer.M1 \
            -o ${name}.hex2

          ''${hex2} --architecture ''${ARCH} \
            ''${ENDIAN_FLAG} \
            -f ''${m2libc}/''${ARCH}/ELF-''${ARCH}-debug.hex2 \
            -f ${name}.hex2 \
            --base-address ''${BASE_ADDRESS} \
            -o ''${out}
        '')
      ];
      inherit version M1 M2 blood-elf-0 hex2 m2libc src ARCH BLOOD_FLAG BASE_ADDRESS ENDIAN_FLAG;
    };
  mkdir = buildMesccToolsExtraUtil "mkdir";
  cp = buildMesccToolsExtraUtil "cp";
  chmod = buildMesccToolsExtraUtil "chmod";
  replace = buildMesccToolsExtraUtil "replace";
in
derivationWithMeta {
  pname = "mescc-tools";
  builder = kaem-unwrapped;
  args = [
    "--verbose"
    "--strict"
    "--file"
    ./build.kaem
  ];
  inherit version M1 M2 blood-elf-0 hex2 mkdir cp chmod replace m2libc src ARCH BLOOD_FLAG BASE_ADDRESS ENDIAN_FLAG;

  meta = with lib; {
    description = "Collection of tools written for use in bootstrapping";
    homepage = "https://github.com/oriansj/mescc-tools";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = [ "i686-linux" ];
  };
}
