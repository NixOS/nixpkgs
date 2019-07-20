{ stdenvNoCC, mingw_w64 }:

stdenvNoCC.mkDerivation {
  name = "${mingw_w64.name}-headers";
  inherit (mingw_w64) src meta;

  patches = [ ./osvi.patch ];

  preConfigure = ''
    cd mingw-w64-headers
  '';

}
