{stdenv, mingw_runtime_headers, w32api_headers}:

stdenv.mkDerivation {
  name = "mingw-headers";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    cp -R ${mingw_runtime_headers}/include/* $out/include
    cp -R ${w32api_headers}/include/* $out/include
  '';
}
