# Mes --- Maxwell Equations of Software
# Copyright © 2017,2019 Jan Nieuwenhuizen <janneke@gnu.org>
# Copyright © 2017,2019 Jeremiah Orians
#
# This file is part of Mes.
#
# Mes is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or (at
# your option) any later version.
#
# Mes is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Mes.  If not, see <http://www.gnu.org/licenses/>.

# This is a translation of stage0-posix/stage0-posix/x86/mescc-tools-mini-kaem.kaem to nix
# https://github.com/oriansj/stage0-posix-x86/blob/56e6b8df3e95f4bc04f8b420a4cd8c82c70b9efa/mescc-tools-mini-kaem.kaem
#
# We have access to mini-kaem at this point but it doesn't support substituting
# environment variables. Without variables there's no way of passing in store inputs,
# or the $out path, other than as command line arguments directly

# Warning all binaries prior to the use of blood-elf will not be readable by
# Objdump, you may need to use ndism or gdb to view the assembly in the binary.

{
  lib,
  derivationWithMeta,
  hostPlatform,
  hex0,
  m2libc,
  src,
  version,
  platforms,
  stage0Arch,
  m2libcArch,
  baseAddress,
}:
rec {
  out = placeholder "out";

  endianFlag = if hostPlatform.isLittleEndian then "--little-endian" else "--big-endian";

  bloodFlags = lib.optional hostPlatform.is64bit "--64";

  run =
    pname: builder: args:
    derivationWithMeta {
      inherit
        pname
        version
        builder
        args
        ;

      meta = with lib; {
        description = "Collection of tools written for use in bootstrapping";
        homepage = "https://github.com/oriansj/stage0-posix";
        license = licenses.gpl3Plus;
        teams = [ teams.minimal-bootstrap ];
        inherit platforms;
      };
    };

  ################################
  # Phase-1 Build hex1 from hex0 #
  ################################

  hex1 = run "hex1" hex0 [
    "${src}/${stage0Arch}/hex1_${stage0Arch}.hex0"
    out
  ];

  # hex1 adds support for single character labels and is available in various forms
  # in mescc-tools/x86_bootstrap to allow you various ways to verify correctness

  ################################
  # Phase-2 Build hex2 from hex1 #
  ################################

  hex2-0 = run "hex2" hex1 [
    "${src}/${stage0Arch}/hex2_${stage0Arch}.hex1"
    out
  ];

  # hex2 adds support for long labels and absolute addresses thus allowing it
  # to function as an effective linker for later stages of the bootstrap
  # This is a minimal version which will be used to bootstrap a much more advanced
  # version in a later stage.

  #################################
  # Phase-2b Build catm from hex2 #
  #################################

  catm =
    if hostPlatform.isAarch64 then
      run "catm" hex1 [
        "${src}/${stage0Arch}/catm_${stage0Arch}.hex1"
        out
      ]
    else
      run "catm" hex2-0 [
        "${src}/${stage0Arch}/catm_${stage0Arch}.hex2"
        out
      ];

  # catm removes the need for cat or shell support for redirection by providing
  # equivalent functionality via catm output_file input1 input2 ... inputN

  ##############################
  # Phase-3 Build M0 from hex2 #
  ##############################

  M0_hex2 = run "M0.hex2" catm [
    out
    "${m2libc}/${m2libcArch}/ELF-${m2libcArch}.hex2"
    "${src}/${stage0Arch}/M0_${stage0Arch}.hex2"
  ];
  M0 = run "M0" hex2-0 [
    M0_hex2
    out
  ];

  # M0 is the architecture specific version of M1 and is by design single
  # architecture only and will be replaced by the C code version of M1

  ################################
  # Phase-4 Build cc_arch from M0 #
  ################################

  cc_arch-0_hex2 = run "cc_arch-0.hex2" M0 [
    "${src}/${stage0Arch}/cc_${m2libcArch}.M1"
    out
  ];
  cc_arch-1_hex2 = run "cc_arch-1.hex2" catm [
    out
    "${m2libc}/${m2libcArch}/ELF-${m2libcArch}.hex2"
    cc_arch-0_hex2
  ];
  cc_arch = run "cc_arch" hex2-0 [
    cc_arch-1_hex2
    out
  ];

  ########################################
  # Phase-5 Build M2-Planet from cc_arch #
  ########################################

  M2-0_c = run "M2-0.c" catm [
    out
    "${m2libc}/${m2libcArch}/linux/bootstrap.c"
    "${src}/M2-Planet/cc.h"
    "${m2libc}/bootstrappable.c"
    "${src}/M2-Planet/cc_globals.c"
    "${src}/M2-Planet/cc_reader.c"
    "${src}/M2-Planet/cc_strings.c"
    "${src}/M2-Planet/cc_types.c"
    "${src}/M2-Planet/cc_core.c"
    "${src}/M2-Planet/cc_macro.c"
    "${src}/M2-Planet/cc.c"
  ];
  M2-0_M1 = run "M2-0.M1" cc_arch [
    M2-0_c
    out
  ];
  M2-0-0_M1 = run "M2-0-0.M1" catm [
    out
    "${m2libc}/${m2libcArch}/${m2libcArch}_defs.M1"
    "${m2libc}/${m2libcArch}/libc-core.M1"
    M2-0_M1
  ];
  M2-0_hex2 = run "M2-0.hex2" M0 [
    M2-0-0_M1
    out
  ];
  M2-0-0_hex2 = run "M2-0-0.hex2" catm [
    out
    "${m2libc}/${m2libcArch}/ELF-${m2libcArch}.hex2"
    M2-0_hex2
  ];
  M2 = run "M2" hex2-0 [
    M2-0-0_hex2
    out
  ];

  ############################################
  # Phase-6 Build blood-elf-0 from C sources #
  ############################################

  blood-elf-0_M1 = run "blood-elf-0.M1" M2 [
    "--architecture"
    m2libcArch
    "-f"
    "${m2libc}/${m2libcArch}/linux/bootstrap.c"
    "-f"
    "${m2libc}/bootstrappable.c"
    "-f"
    "${src}/mescc-tools/stringify.c"
    "-f"
    "${src}/mescc-tools/blood-elf.c"
    "--bootstrap-mode"
    "-o"
    out
  ];

  blood-elf-0-0_M1 = run "blood-elf-0-0.M1" catm [
    out
    "${m2libc}/${m2libcArch}/${m2libcArch}_defs.M1"
    "${m2libc}/${m2libcArch}/libc-core.M1"
    blood-elf-0_M1
  ];
  blood-elf-0_hex2 = run "blood-elf-0.hex2" M0 [
    blood-elf-0-0_M1
    out
  ];
  blood-elf-0-0_hex2 = run "blood-elf-0-0.hex2" catm [
    out
    "${m2libc}/${m2libcArch}/ELF-${m2libcArch}.hex2"
    blood-elf-0_hex2
  ];
  blood-elf-0 = run "blood-elf-0" hex2-0 [
    blood-elf-0-0_hex2
    out
  ];

  # This is the last stage where the binaries will not have debug info
  # and the last piece built that isn't part of the output binaries

  #####################################
  # Phase-7 Build M1-0 from C sources #
  #####################################

  M1-macro-0_M1 = run "M1-macro-0.M1" M2 [
    "--architecture"
    m2libcArch
    "-f"
    "${m2libc}/${m2libcArch}/linux/bootstrap.c"
    "-f"
    "${m2libc}/bootstrappable.c"
    "-f"
    "${src}/mescc-tools/stringify.c"
    "-f"
    "${src}/mescc-tools/M1-macro.c"
    "--bootstrap-mode"
    "--debug"
    "-o"
    out
  ];

  M1-macro-0-footer_M1 = run "M1-macro-0-footer.M1" blood-elf-0 (
    bloodFlags
    ++ [
      "-f"
      M1-macro-0_M1
      endianFlag
      "-o"
      out
    ]
  );
  M1-macro-0-0_M1 = run "M1-macro-0-0.M1" catm [
    out
    "${m2libc}/${m2libcArch}/${m2libcArch}_defs.M1"
    "${m2libc}/${m2libcArch}/libc-core.M1"
    M1-macro-0_M1
    M1-macro-0-footer_M1
  ];
  M1-macro-0_hex2 = run "M1-macro-0.hex2" M0 [
    M1-macro-0-0_M1
    out
  ];
  M1-macro-0-0_hex2 = run "M1-macro-0-0.hex2" catm [
    out
    "${m2libc}/${m2libcArch}/ELF-${m2libcArch}-debug.hex2"
    M1-macro-0_hex2
  ];
  M1-0 = run "M1-0" hex2-0 [
    M1-macro-0-0_hex2
    out
  ];

  # This is the last stage where catm will need to be used and the last stage where
  # M0 is used, as we will being using it's much more powerful and cross-platform
  # version with a bunch of extra goodies.

  #######################################
  # Phase-8 Build hex2-1 from C sources #
  #######################################

  hex2_linker-0_M1 = run "hex2_linker-0.M1" M2 [
    "--architecture"
    m2libcArch
    "-f"
    "${m2libc}/sys/types.h"
    "-f"
    "${m2libc}/stddef.h"
    "-f"
    "${m2libc}/${m2libcArch}/linux/unistd.c"
    "-f"
    "${m2libc}/${m2libcArch}/linux/fcntl.c"
    "-f"
    "${m2libc}/fcntl.c"
    "-f"
    "${m2libc}/${m2libcArch}/linux/sys/stat.c"
    "-f"
    "${m2libc}/stdlib.c"
    "-f"
    "${m2libc}/stdio.h"
    "-f"
    "${m2libc}/stdio.c"
    "-f"
    "${m2libc}/bootstrappable.c"
    "-f"
    "${src}/mescc-tools/hex2.h"
    "-f"
    "${src}/mescc-tools/hex2_linker.c"
    "-f"
    "${src}/mescc-tools/hex2_word.c"
    "-f"
    "${src}/mescc-tools/hex2.c"
    "--debug"
    "-o"
    out
  ];

  hex2_linker-0-footer_M1 = run "hex2_linker-0-footer.M1" blood-elf-0 (
    bloodFlags
    ++ [
      "-f"
      hex2_linker-0_M1
      endianFlag
      "-o"
      out
    ]
  );

  hex2_linker-0_hex2 = run "hex2_linker-0.hex2" M1-0 [
    "--architecture"
    m2libcArch
    endianFlag
    "-f"
    "${m2libc}/${m2libcArch}/${m2libcArch}_defs.M1"
    "-f"
    "${m2libc}/${m2libcArch}/libc-full.M1"
    "-f"
    hex2_linker-0_M1
    "-f"
    hex2_linker-0-footer_M1
    "-o"
    out
  ];

  hex2_linker-0-0_hex2 = run "hex2_linker-0-0.hex2" catm [
    out
    "${m2libc}/${m2libcArch}/ELF-${m2libcArch}-debug.hex2"
    hex2_linker-0_hex2
  ];

  hex2-1 = run "hex2-1" hex2-0 [
    hex2_linker-0-0_hex2
    out
  ];

  # This is the last stage where we will be using the handwritten hex2 and instead
  # be using the far more powerful, cross-platform version with a bunch more goodies

  ###################################
  # Phase-9 Build M1 from C sources #
  ###################################

  M1-macro-1_M1 = run "M1-macro-1.M1" M2 [
    "--architecture"
    m2libcArch
    "-f"
    "${m2libc}/sys/types.h"
    "-f"
    "${m2libc}/stddef.h"
    "-f"
    "${m2libc}/${m2libcArch}/linux/fcntl.c"
    "-f"
    "${m2libc}/fcntl.c"
    "-f"
    "${m2libc}/${m2libcArch}/linux/unistd.c"
    "-f"
    "${m2libc}/string.c"
    "-f"
    "${m2libc}/stdlib.c"
    "-f"
    "${m2libc}/stdio.h"
    "-f"
    "${m2libc}/stdio.c"
    "-f"
    "${m2libc}/bootstrappable.c"
    "-f"
    "${src}/mescc-tools/stringify.c"
    "-f"
    "${src}/mescc-tools/M1-macro.c"
    "--debug"
    "-o"
    out
  ];

  M1-macro-1-footer_M1 = run "M1-macro-1-footer.M1" blood-elf-0 (
    bloodFlags
    ++ [
      "-f"
      M1-macro-1_M1
      endianFlag
      "-o"
      out
    ]
  );

  M1-macro-1_hex2 = run "M1-macro-1.hex2" M1-0 [
    "--architecture"
    m2libcArch
    endianFlag
    "-f"
    "${m2libc}/${m2libcArch}/${m2libcArch}_defs.M1"
    "-f"
    "${m2libc}/${m2libcArch}/libc-full.M1"
    "-f"
    M1-macro-1_M1
    "-f"
    M1-macro-1-footer_M1
    "-o"
    out
  ];

  M1 = run "M1" hex2-1 [
    "--architecture"
    m2libcArch
    endianFlag
    "--base-address"
    baseAddress
    "-f"
    "${m2libc}/${m2libcArch}/ELF-${m2libcArch}-debug.hex2"
    "-f"
    M1-macro-1_hex2
    "-o"
    out
  ];

  ######################################
  # Phase-10 Build hex2 from C sources #
  ######################################

  hex2_linker-2_M1 = run "hex2_linker-2.M1" M2 [
    "--architecture"
    m2libcArch
    "-f"
    "${m2libc}/sys/types.h"
    "-f"
    "${m2libc}/stddef.h"
    "-f"
    "${m2libc}/${m2libcArch}/linux/unistd.c"
    "-f"
    "${m2libc}/${m2libcArch}/linux/fcntl.c"
    "-f"
    "${m2libc}/fcntl.c"
    "-f"
    "${m2libc}/${m2libcArch}/linux/sys/stat.c"
    "-f"
    "${m2libc}/stdlib.c"
    "-f"
    "${m2libc}/stdio.h"
    "-f"
    "${m2libc}/stdio.c"
    "-f"
    "${m2libc}/bootstrappable.c"
    "-f"
    "${src}/mescc-tools/hex2.h"
    "-f"
    "${src}/mescc-tools/hex2_linker.c"
    "-f"
    "${src}/mescc-tools/hex2_word.c"
    "-f"
    "${src}/mescc-tools/hex2.c"
    "--debug"
    "-o"
    out
  ];

  hex2_linker-2-footer_M1 = run "hex2_linker-2-footer.M1" blood-elf-0 (
    bloodFlags
    ++ [
      "-f"
      hex2_linker-2_M1
      endianFlag
      "-o"
      out
    ]
  );

  hex2_linker-2_hex2 = run "hex2_linker-2.hex2" M1 [
    "--architecture"
    m2libcArch
    endianFlag
    "-f"
    "${m2libc}/${m2libcArch}/${m2libcArch}_defs.M1"
    "-f"
    "${m2libc}/${m2libcArch}/libc-full.M1"
    "-f"
    hex2_linker-2_M1
    "-f"
    hex2_linker-2-footer_M1
    "-o"
    out
  ];

  hex2 = run "hex2" hex2-1 [
    "--architecture"
    m2libcArch
    endianFlag
    "--base-address"
    baseAddress
    "-f"
    "${m2libc}/${m2libcArch}/ELF-${m2libcArch}-debug.hex2"
    "-f"
    hex2_linker-2_hex2
    "-o"
    out
  ];

  ######################################
  # Phase-11 Build kaem from C sources #
  ######################################

  kaem_M1 = run "kaem.M1" M2 [
    "--architecture"
    m2libcArch
    "-f"
    "${m2libc}/sys/types.h"
    "-f"
    "${m2libc}/stddef.h"
    "-f"
    "${m2libc}/string.c"
    "-f"
    "${m2libc}/${m2libcArch}/linux/unistd.c"
    "-f"
    "${m2libc}/${m2libcArch}/linux/fcntl.c"
    "-f"
    "${m2libc}/fcntl.c"
    "-f"
    "${m2libc}/stdlib.c"
    "-f"
    "${m2libc}/stdio.h"
    "-f"
    "${m2libc}/stdio.c"
    "-f"
    "${m2libc}/bootstrappable.c"
    "-f"
    "${src}/mescc-tools/Kaem/kaem.h"
    "-f"
    "${src}/mescc-tools/Kaem/variable.c"
    "-f"
    "${src}/mescc-tools/Kaem/kaem_globals.c"
    "-f"
    "${src}/mescc-tools/Kaem/kaem.c"
    "--debug"
    "-o"
    out
  ];

  kaem-footer_M1 = run "kaem-footer.M1" blood-elf-0 (
    bloodFlags
    ++ [
      "-f"
      kaem_M1
      endianFlag
      "-o"
      out
    ]
  );

  kaem_hex2 = run "kaem.hex2" M1 [
    "--architecture"
    m2libcArch
    endianFlag
    "-f"
    "${m2libc}/${m2libcArch}/${m2libcArch}_defs.M1"
    "-f"
    "${m2libc}/${m2libcArch}/libc-full.M1"
    "-f"
    kaem_M1
    "-f"
    kaem-footer_M1
    "-o"
    out
  ];

  kaem-unwrapped = run "kaem-unwrapped" hex2 [
    "--architecture"
    m2libcArch
    endianFlag
    "-f"
    "${m2libc}/${m2libcArch}/ELF-${m2libcArch}-debug.hex2"
    "-f"
    kaem_hex2
    "--base-address"
    baseAddress
    "-o"
    out
  ];
}
