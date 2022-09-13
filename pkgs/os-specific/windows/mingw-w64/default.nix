{ lib, stdenv, windows, fetchurl }:

let
  version = "10.0.0";
in stdenv.mkDerivation {
  pname = "mingw-w64";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    hash = "sha256-umtDCu1yxjo3aFMfaj/8Kw/eLFejslFFDc9ImolPCJQ=";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--enable-idl"
    "--enable-secure-api"
  ];

  enableParallelBuilding = true;

  buildInputs = [ windows.mingw_w64_headers ];
  hardeningDisable = [ "stackprotector" "fortify" ];

  meta = {
    platforms = lib.platforms.windows;
  };
}
