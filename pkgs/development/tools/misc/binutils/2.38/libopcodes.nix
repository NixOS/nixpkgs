{
  lib,
  stdenv,
  buildPackages,
  autoreconfHook,
  bison,
  binutils-unwrapped_2_38,
  libiberty,
  libbfd_2_38,
}:

stdenv.mkDerivation {
  pname = "libopcodes";
  inherit (binutils-unwrapped_2_38) version src;

  outputs = [
    "out"
    "dev"
  ];

  patches = binutils-unwrapped_2_38.patches ++ [
    ./build-components-separately.patch
  ];

  # We just want to build libopcodes
  postPatch = ''
    cd opcodes
    find . ../include/opcode -type f -exec sed {} -i -e 's/"bfd.h"/<bfd.h>/' \;
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoreconfHook
    bison
  ];
  buildInputs = [ libiberty ];
  # dis-asm.h includes bfd.h
  propagatedBuildInputs = [ libbfd_2_38 ];

  configurePlatforms = [
    "build"
    "host"
  ];
  configureFlags = [
    "--enable-targets=all"
    "--enable-64-bit-bfd"
    "--enable-install-libbfd"
    "--enable-shared"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Library from binutils for manipulating machine code";
    homepage = "https://www.gnu.org/software/binutils/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericson2314 ];
    platforms = platforms.unix;
  };
}
