# The Nix `gcc' stdenv.mkDerivation is not directly usable, since it doesn't
# know where the C library and standard header files are.  Therefore
# the compiler produced by that package cannot be installed directly
# in a user environment and used from the command line.  This
# stdenv.mkDerivation provides a wrapper that sets up the right environment
# variables so that the compiler and the linker just "work".

{stdenv, gcc, mingwRuntime, w32api, binutils, shell}:

stdenv.mkDerivation {
  name = "mingw-gcc-wrapper"; 
  builder = ./builder.sh;
  substitute = ../../../build-support/substitute/substitute.sh;
  setupHook = ../../../build-support/gcc-wrapper/setup-hook.sh;
  gccWrapper = ../../../build-support/gcc-wrapper/gcc-wrapper.sh;
  ldWrapper = ../../../build-support/gcc-wrapper/ld-wrapper.sh;
  utils = ../../../build-support/gcc-wrapper/utils.sh;
  addFlags = ../../../build-support/gcc-wrapper/add-flags;
  inherit gcc mingwRuntime w32api binutils shell;
  langC = gcc.langC;
  langCC = gcc.langCC;
  langF77 = gcc.langF77;
}
