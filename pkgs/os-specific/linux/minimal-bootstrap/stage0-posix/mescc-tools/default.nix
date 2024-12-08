{ lib
, derivationWithMeta
, hostPlatform
, kaem-unwrapped
, M1
, M2
, blood-elf-0
, hex2
, m2libc
, src
, version
, platforms
, m2libcArch
, baseAddress
}:

let
  endianFlag = if hostPlatform.isLittleEndian then "--little-endian" else "--big-endian";
  bloodFlag = if hostPlatform.is64bit then "--64" else " ";

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
          ''${M2} --architecture ${m2libcArch} \
            -f ''${m2libc}/sys/types.h \
            -f ''${m2libc}/stddef.h \
            -f ''${m2libc}/${m2libcArch}/linux/fcntl.c \
            -f ''${m2libc}/fcntl.c \
            -f ''${m2libc}/${m2libcArch}/linux/unistd.c \
            -f ''${m2libc}/${m2libcArch}/linux/sys/stat.c \
            -f ''${m2libc}/stdlib.c \
            -f ''${m2libc}/stdio.h \
            -f ''${m2libc}/stdio.c \
            -f ''${m2libc}/string.c \
            -f ''${m2libc}/bootstrappable.c \
            -f ''${src}/mescc-tools-extra/${name}.c \
            --debug \
            -o ${name}.M1

          ''${blood-elf-0} ${endianFlag} ${bloodFlag} -f ${name}.M1 -o ${name}-footer.M1

          ''${M1} --architecture ${m2libcArch} \
            ${endianFlag} \
            -f ''${m2libc}/${m2libcArch}/${m2libcArch}_defs.M1 \
            -f ''${m2libc}/${m2libcArch}/libc-full.M1 \
            -f ${name}.M1 \
            -f ${name}-footer.M1 \
            -o ${name}.hex2

          ''${hex2} --architecture ${m2libcArch} \
            ${endianFlag} \
            -f ''${m2libc}/${m2libcArch}/ELF-${m2libcArch}-debug.hex2 \
            -f ${name}.hex2 \
            --base-address ${baseAddress} \
            -o ''${out}
        '')
      ];
      inherit version M1 M2 blood-elf-0 hex2 m2libc src;
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
  inherit version M1 M2 blood-elf-0 hex2 mkdir cp chmod replace m2libc src m2libcArch baseAddress bloodFlag endianFlag;

  meta = with lib; {
    description = "Collection of tools written for use in bootstrapping";
    homepage = "https://github.com/oriansj/mescc-tools";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    inherit platforms;
  };
}
