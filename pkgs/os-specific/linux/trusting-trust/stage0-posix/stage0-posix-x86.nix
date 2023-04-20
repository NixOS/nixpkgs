# This is a translation of stage0-posix/stage0-posix/x86/mescc-tools-mini-kaem.kaem to nix
# https://github.com/oriansj/stage0-posix-x86/blob/56e6b8df3e95f4bc04f8b420a4cd8c82c70b9efa/mescc-tools-mini-kaem.kaem

# Warning all binaries prior to the use of blood-elf will not be readable by
# Objdump, you may need to use ndism or gdb to view the assembly in the binary.

{ runBareCommand
, system
, hex0
, stage0-posix-x86-src
, m2libc
, m2-planet-src
, mescc-tools-src
}:
rec {
  out = placeholder "out";

  ################################
  # Phase-1 Build hex1 from hex0 #
  ################################

  hex1 = runBareCommand "hex1" hex0 ["${stage0-posix-x86-src}/hex1_x86.hex0" out];

  # hex1 adds support for single character labels and is available in various forms
  # in mescc-tools/x86_bootstrap to allow you various ways to verify correctness

  ################################
  # Phase-2 Build hex2 from hex1 #
  ################################

  hex2-0 = runBareCommand "hex2" hex1 ["${stage0-posix-x86-src}/hex2_x86.hex1" out];

  # hex2 adds support for long labels and absolute addresses thus allowing it
  # to function as an effective linker for later stages of the bootstrap
  # This is a minimal version which will be used to bootstrap a much more advanced
  # version in a later stage.

  #################################
  # Phase-2b Build catm from hex2 #
  #################################

  catm = runBareCommand "catm" hex2-0 ["${stage0-posix-x86-src}/catm_x86.hex2" out];

  # catm removes the need for cat or shell support for redirection by providing
  # equivalent functionality via catm output_file input1 input2 ... inputN

  ##############################
  # Phase-3 Build M0 from hex2 #
  ##############################

  M0_hex2 = runBareCommand "M0.hex2" catm [out "${stage0-posix-x86-src}/ELF-i386.hex2" "${stage0-posix-x86-src}/M0_x86.hex2"];
  M0 = runBareCommand "M0" hex2-0 [M0_hex2 out];

  # M0 is the architecture specific version of M1 and is by design single
  # architecture only and will be replaced by the C code version of M1

  ################################
  # Phase-4 Build cc_x86 from M0 #
  ################################

  cc_x86-0_hex2 = runBareCommand "cc_x86-0.hex2" M0 ["${stage0-posix-x86-src}/cc_x86.M1" out];
  cc_x86-1_hex2 = runBareCommand "cc_x86-1.hex2" catm [out "${stage0-posix-x86-src}/ELF-i386.hex2" cc_x86-0_hex2];
  cc_x86 = runBareCommand "cc_x86" hex2-0 [cc_x86-1_hex2 out];

  #######################################
  # Phase-5 Build M2-Planet from cc_x86 #
  #######################################

  M2-0_c = runBareCommand "M2-0.c" catm [
    out
    "${m2libc}/x86/linux/bootstrap.c"
    "${m2-planet-src}/cc.h"
    "${m2libc}/bootstrappable.c"
    "${m2-planet-src}/cc_globals.c"
    "${m2-planet-src}/cc_reader.c"
    "${m2-planet-src}/cc_strings.c"
    "${m2-planet-src}/cc_types.c"
    "${m2-planet-src}/cc_core.c"
    "${m2-planet-src}/cc_macro.c"
    "${m2-planet-src}/cc.c"
  ];
  M2-0_M1 = runBareCommand "M2-0.M1" cc_x86 [M2-0_c out];
  M2-0-0_M1 = runBareCommand "M2-0-0.M1" catm [out "${stage0-posix-x86-src}/x86_defs.M1" "${stage0-posix-x86-src}/libc-core.M1" M2-0_M1];
  M2-0_hex2 = runBareCommand "M2-0.hex2" M0 [M2-0-0_M1 out];
  M2-0-0_hex2 = runBareCommand "M2-0-0.hex2" catm [out "${stage0-posix-x86-src}/ELF-i386.hex2" M2-0_hex2];
  M2 = runBareCommand "M2" hex2-0 [M2-0-0_hex2 out];

  ############################################
  # Phase-6 Build blood-elf-0 from C sources #
  ############################################

  blood-elf-0_M1 = runBareCommand "blood-elf-0.M1" M2 [
    "--architecture" "x86"
    "-f" "${m2libc}/x86/linux/bootstrap.c"
    "-f" "${m2libc}/bootstrappable.c"
    "-f" "${mescc-tools-src}/stringify.c"
    "-f" "${mescc-tools-src}/blood-elf.c"
    "--bootstrap-mode"
    "-o" out
  ];

  blood-elf-0-0_M1 = runBareCommand "blood-elf-0-0.M1" catm [out "${m2libc}/x86/x86_defs.M1" "${m2libc}/x86/libc-core.M1" blood-elf-0_M1];
  blood-elf-0_hex2 = runBareCommand "blood-elf-0.hex2" M0 [blood-elf-0-0_M1 out];
  blood-elf-0-0_hex2 = runBareCommand "blood-elf-0-0.hex2" catm [out "${m2libc}/x86/ELF-x86.hex2" blood-elf-0_hex2];
  blood-elf-0 = runBareCommand "blood-elf-0" hex2-0 [blood-elf-0-0_hex2 out];

  # This is the last stage where the binaries will not have debug info
  # and the last piece built that isn't part of the output binaries

  #####################################
  # Phase-7 Build M1-0 from C sources #
  #####################################

  M1-macro-0_M1 = runBareCommand "M1-macro-0.M1" M2 [
    "--architecture" "x86"
    "-f" "${m2libc}/x86/linux/bootstrap.c"
    "-f" "${m2libc}/bootstrappable.c"
    "-f" "${mescc-tools-src}/stringify.c"
    "-f" "${mescc-tools-src}/M1-macro.c"
    "--bootstrap-mode"
    "--debug"
    "-o" out
  ];

  M1-macro-0-footer_M1 = runBareCommand "M1-macro-0-footer.M1" blood-elf-0 ["-f" M1-macro-0_M1 "--little-endian" "-o" out];
  M1-macro-0-0_M1 = runBareCommand "M1-macro-0-0.M1" catm [out "${m2libc}/x86/x86_defs.M1" "${m2libc}/x86/libc-core.M1" M1-macro-0_M1 M1-macro-0-footer_M1];
  M1-macro-0_hex2 = runBareCommand "M1-macro-0.hex2" M0 [M1-macro-0-0_M1 out];
  M1-macro-0-0_hex2 = runBareCommand "M1-macro-0-0.hex2" catm [out "${m2libc}/x86/ELF-x86-debug.hex2" M1-macro-0_hex2];
  M1-0 = runBareCommand "M1-0" hex2-0 [M1-macro-0-0_hex2 out];

  # This is the last stage where catm will need to be used and the last stage where
  # M0 is used, as we will being using it's much more powerful and cross-platform
  # version with a bunch of extra goodies.

  #######################################
  # Phase-8 Build hex2-1 from C sources #
  #######################################

  hex2_linker-0_M1 = runBareCommand "hex2_linker-0.M1" M2 [
    "--architecture" "x86"
    "-f" "${m2libc}/sys/types.h"
    "-f" "${m2libc}/stddef.h"
    "-f" "${m2libc}/x86/linux/unistd.c"
    "-f" "${m2libc}/x86/linux/fcntl.c"
    "-f" "${m2libc}/fcntl.c"
    "-f" "${m2libc}/x86/linux/sys/stat.c"
    "-f" "${m2libc}/stdlib.c"
    "-f" "${m2libc}/stdio.h"
    "-f" "${m2libc}/stdio.c"
    "-f" "${m2libc}/bootstrappable.c"
    "-f" "${mescc-tools-src}/hex2.h"
    "-f" "${mescc-tools-src}/hex2_linker.c"
    "-f" "${mescc-tools-src}/hex2_word.c"
    "-f" "${mescc-tools-src}/hex2.c"
    "--debug"
    "-o" out
  ];

  hex2_linker-0-footer_M1 = runBareCommand "hex2_linker-0-footer.M1" blood-elf-0 ["-f" hex2_linker-0_M1 "--little-endian" "-o" out];

  hex2_linker-0_hex2 = runBareCommand "hex2_linker-0.hex2" M1-0 [
    "--architecture" "x86"
    "--little-endian"
    "-f" "${m2libc}/x86/x86_defs.M1"
    "-f" "${m2libc}/x86/libc-full.M1"
    "-f" hex2_linker-0_M1
    "-f" hex2_linker-0-footer_M1
    "-o" out
  ];

  hex2_linker-0-0_hex2 = runBareCommand "hex2_linker-0-0.hex2" catm [out "${m2libc}/x86/ELF-x86-debug.hex2" hex2_linker-0_hex2];

  hex2-1 = runBareCommand "hex2-1" hex2-0 [hex2_linker-0-0_hex2 out];

  # This is the last stage where we will be using the handwritten hex2 and instead
  # be using the far more powerful, cross-platform version with a bunch more goodies

  ###################################
  # Phase-9 Build M1 from C sources #
  ###################################

  M1-macro-1_M1 = runBareCommand "M1-macro-1.M1" M2 [
    "--architecture" "x86"
    "-f" "${m2libc}/sys/types.h"
    "-f" "${m2libc}/stddef.h"
    "-f" "${m2libc}/x86/linux/fcntl.c"
    "-f" "${m2libc}/fcntl.c"
    "-f" "${m2libc}/x86/linux/unistd.c"
    "-f" "${m2libc}/string.c"
    "-f" "${m2libc}/stdlib.c"
    "-f" "${m2libc}/stdio.h"
    "-f" "${m2libc}/stdio.c"
    "-f" "${m2libc}/bootstrappable.c"
    "-f" "${mescc-tools-src}/stringify.c"
    "-f" "${mescc-tools-src}/M1-macro.c"
    "--debug"
    "-o" out
  ];

  M1-macro-1-footer_M1 = runBareCommand "M1-macro-1-footer.M1" blood-elf-0 ["-f" M1-macro-1_M1 "--little-endian" "-o" out];

  M1-macro-1_hex2 = runBareCommand "M1-macro-1.hex2" M1-0 [
    "--architecture" "x86"
    "--little-endian"
    "-f" "${m2libc}/x86/x86_defs.M1"
    "-f" "${m2libc}/x86/libc-full.M1"
    "-f" M1-macro-1_M1
    "-f" M1-macro-1-footer_M1
    "-o" out
  ];

  M1 = runBareCommand "M1" hex2-1 [
    "--architecture" "x86"
    "--little-endian"
    "--base-address" "0x8048000"
    "-f" "${m2libc}/x86/ELF-x86-debug.hex2"
    "-f" M1-macro-1_hex2
    "-o" out
  ];

  ######################################
  # Phase-10 Build hex2 from C sources #
  ######################################

  hex2_linker-2_M1 = runBareCommand "hex2_linker-2.M1" M2 [
    "--architecture" "x86"
    "-f" "${m2libc}/sys/types.h"
    "-f" "${m2libc}/stddef.h"
    "-f" "${m2libc}/x86/linux/unistd.c"
    "-f" "${m2libc}/x86/linux/fcntl.c"
    "-f" "${m2libc}/fcntl.c"
    "-f" "${m2libc}/x86/linux/sys/stat.c"
    "-f" "${m2libc}/stdlib.c"
    "-f" "${m2libc}/stdio.h"
    "-f" "${m2libc}/stdio.c"
    "-f" "${m2libc}/bootstrappable.c"
    "-f" "${mescc-tools-src}/hex2.h"
    "-f" "${mescc-tools-src}/hex2_linker.c"
    "-f" "${mescc-tools-src}/hex2_word.c"
    "-f" "${mescc-tools-src}/hex2.c"
    "--debug"
    "-o" out
  ];

  hex2_linker-2-footer_M1 = runBareCommand "hex2_linker-2-footer.M1" blood-elf-0 ["-f" hex2_linker-2_M1 "--little-endian" "-o" out];

  hex2_linker-2_hex2 = runBareCommand "hex2_linker-2.hex2" M1 [
    "--architecture" "x86"
    "--little-endian"
    "-f" "${m2libc}/x86/x86_defs.M1"
    "-f" "${m2libc}/x86/libc-full.M1"
    "-f" hex2_linker-2_M1
    "-f" hex2_linker-2-footer_M1
    "-o" out
  ];

  hex2 = runBareCommand "hex2" hex2-1 [
    "--architecture" "x86"
    "--little-endian"
    "--base-address" "0x8048000"
    "-f" "${m2libc}/x86/ELF-x86-debug.hex2"
    "-f" hex2_linker-2_hex2
    "-o" out
  ];

  ######################################
  # Phase-11 Build kaem from C sources #
  ######################################

  kaem_M1 = runBareCommand "kaem.M1" M2 [
    "--architecture" "x86"
    "-f" "${m2libc}/sys/types.h"
    "-f" "${m2libc}/stddef.h"
    "-f" "${m2libc}/string.c"
    "-f" "${m2libc}/x86/linux/unistd.c"
    "-f" "${m2libc}/x86/linux/fcntl.c"
    "-f" "${m2libc}/fcntl.c"
    "-f" "${m2libc}/stdlib.c"
    "-f" "${m2libc}/stdio.h"
    "-f" "${m2libc}/stdio.c"
    "-f" "${m2libc}/bootstrappable.c"
    "-f" "${mescc-tools-src}/Kaem/kaem.h"
    "-f" "${mescc-tools-src}/Kaem/variable.c"
    "-f" "${mescc-tools-src}/Kaem/kaem_globals.c"
    "-f" "${mescc-tools-src}/Kaem/kaem.c"
    "--debug"
    "-o" out
  ];

  kaem-footer_M1 = runBareCommand "kaem-footer.M1" blood-elf-0 ["-f" kaem_M1 "--little-endian" "-o" out];

  kaem_hex2 = runBareCommand "kaem.hex2" M1 [
    "--architecture" "x86"
    "--little-endian"
    "-f" "${m2libc}/x86/x86_defs.M1"
    "-f" "${m2libc}/x86/libc-full.M1"
    "-f" kaem_M1
    "-f" kaem-footer_M1
    "-o" out
  ];

  kaem-unwrapped = runBareCommand "kaem-unwrapped" hex2 [
    "--architecture" "x86"
    "--little-endian"
    "-f" "${m2libc}/x86/ELF-x86-debug.hex2"
    "-f" kaem_hex2
    "--base-address" "0x8048000"
    "-o" out
  ];
}
