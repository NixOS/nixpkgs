{ stdenvNoCC, mingw_w64 }:

let
  crt = stdenvNoCC.hostPlatform.libc;
in stdenvNoCC.mkDerivation {
  name = "${mingw_w64.name}-headers";
  inherit (mingw_w64) src meta;

  preConfigure = ''
    cd mingw-w64-headers
  '';

  configureFlags = [
    "--enable-idl"
    "--enable-secure-api"
    "--with-default-msvcrt=${crt}"
  ];

}
