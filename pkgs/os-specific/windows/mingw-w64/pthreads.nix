{
  lib,
  stdenv,
  mingw_w64_headers,
  # Rustc require 'libpthread.a' when targeting 'x86_64-pc-windows-gnu'.
  # Enabling this makes it work out of the box instead of failing.
  withStatic ? true,
}:

stdenv.mkDerivation {
  pname = "mingw_w64-pthreads";
  inherit (mingw_w64_headers) version src meta;

  configureFlags = [ (lib.enableFeature withStatic "static") ];

  preConfigure = ''
    cd mingw-w64-libraries/winpthreads
  '';

  # Supplies the pthreads API MinGW itself lacks, so a libgcc built against it
  # gets the "posix" threading model rather than the bare libc's "win32". Same
  # attribute a libc uses to declare what it provides; see `threadModel` in
  # pkgs/development/compilers/gcc/ng/common/libgcc/default.nix.
  passthru.threadModel = "posix";
}
