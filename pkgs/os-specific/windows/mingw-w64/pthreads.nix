{ stdenv, mingw_w64 }:

stdenv.mkDerivation {
  name = "${mingw_w64.name}-pthreads";
  inherit (mingw_w64) src meta;

  configureFlags = [
    # Rustc require 'libpthread.a' when targeting 'x86_64-pc-windows-gnu'.
    # Enabling this makes it work out of the box instead of failing.
    "--enable-static"
  ];

  preConfigure = ''
    cd mingw-w64-libraries/winpthreads
  '';
}
