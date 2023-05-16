{ lib
, derivationWithMeta
<<<<<<< HEAD
, hostPlatform
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, kaem-unwrapped
, M1
, M2
, blood-elf-0
, hex2
, m2libc
, src
, version
<<<<<<< HEAD
, platforms
, m2libcArch
, baseAddress
}:

let
  endianFlag = if hostPlatform.isLittleEndian then "--little-endian" else "--big-endian";
  bloodFlag = if hostPlatform.is64bit then "--64" else " ";
=======
}:

let
  ARCH = "x86";
  BLOOD_FLAG = " ";
  BASE_ADDRESS = "0x8048000";
  ENDIAN_FLAG = "--little-endian";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
          ''${M2} --architecture ${m2libcArch} \
            -f ''${m2libc}/sys/types.h \
            -f ''${m2libc}/stddef.h \
            -f ''${m2libc}/${m2libcArch}/linux/fcntl.c \
            -f ''${m2libc}/fcntl.c \
            -f ''${m2libc}/${m2libcArch}/linux/unistd.c \
            -f ''${m2libc}/${m2libcArch}/linux/sys/stat.c \
=======
          ''${M2} --architecture ''${ARCH} \
            -f ''${m2libc}/sys/types.h \
            -f ''${m2libc}/stddef.h \
            -f ''${m2libc}/''${ARCH}/linux/fcntl.c \
            -f ''${m2libc}/fcntl.c \
            -f ''${m2libc}/''${ARCH}/linux/unistd.c \
            -f ''${m2libc}/''${ARCH}/linux/sys/stat.c \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
            -f ''${m2libc}/stdlib.c \
            -f ''${m2libc}/stdio.h \
            -f ''${m2libc}/stdio.c \
            -f ''${m2libc}/string.c \
            -f ''${m2libc}/bootstrappable.c \
            -f ''${src}/mescc-tools-extra/${name}.c \
            --debug \
            -o ${name}.M1

<<<<<<< HEAD
          ''${blood-elf-0} ${endianFlag} ${bloodFlag} -f ${name}.M1 -o ${name}-footer.M1

          ''${M1} --architecture ${m2libcArch} \
            ${endianFlag} \
            -f ''${m2libc}/${m2libcArch}/${m2libcArch}_defs.M1 \
            -f ''${m2libc}/${m2libcArch}/libc-full.M1 \
=======
          ''${blood-elf-0} ''${ENDIAN_FLAG} -f ${name}.M1 -o ${name}-footer.M1

          ''${M1} --architecture ''${ARCH} \
            ''${ENDIAN_FLAG} \
            -f ''${m2libc}/''${ARCH}/''${ARCH}_defs.M1 \
            -f ''${m2libc}/''${ARCH}/libc-full.M1 \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
            -f ${name}.M1 \
            -f ${name}-footer.M1 \
            -o ${name}.hex2

<<<<<<< HEAD
          ''${hex2} --architecture ${m2libcArch} \
            ${endianFlag} \
            -f ''${m2libc}/${m2libcArch}/ELF-${m2libcArch}-debug.hex2 \
            -f ${name}.hex2 \
            --base-address ${baseAddress} \
            -o ''${out}
        '')
      ];
      inherit version M1 M2 blood-elf-0 hex2 m2libc src;
=======
          ''${hex2} --architecture ''${ARCH} \
            ''${ENDIAN_FLAG} \
            -f ''${m2libc}/''${ARCH}/ELF-''${ARCH}-debug.hex2 \
            -f ${name}.hex2 \
            --base-address ''${BASE_ADDRESS} \
            -o ''${out}
        '')
      ];
      inherit version M1 M2 blood-elf-0 hex2 m2libc src ARCH BLOOD_FLAG BASE_ADDRESS ENDIAN_FLAG;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  inherit version M1 M2 blood-elf-0 hex2 mkdir cp chmod replace m2libc src m2libcArch baseAddress bloodFlag endianFlag;
=======
  inherit version M1 M2 blood-elf-0 hex2 mkdir cp chmod replace m2libc src ARCH BLOOD_FLAG BASE_ADDRESS ENDIAN_FLAG;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Collection of tools written for use in bootstrapping";
    homepage = "https://github.com/oriansj/mescc-tools";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = teams.minimal-bootstrap.members;
    inherit platforms;
=======
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
