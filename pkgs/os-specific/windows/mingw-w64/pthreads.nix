{ stdenv, mingw_w64_headers }:

stdenv.mkDerivation {
  pname = "mingw_w64-pthreads";
  inherit (mingw_w64_headers) version src meta;

  configureFlags = [
    # Rustc require 'libpthread.a' when targeting 'x86_64-pc-windows-gnu'.
    # Enabling this makes it work out of the box instead of failing.
    "--enable-static"
  ];

  preConfigure = ''
    cd mingw-w64-libraries/winpthreads
  '';
}
