{ lib
, stdenv
, windows
, autoreconfHook
, mingw_w64_headers
}:

stdenv.mkDerivation {
  pname = "mingw-w64";
  inherit (mingw_w64_headers) version src meta;

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--enable-idl"
    "--enable-secure-api"
  ] ++ lib.optionals (stdenv.targetPlatform.libc == "ucrt") [
    "--with-default-msvcrt=ucrt"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ windows.mingw_w64_headers ];
  hardeningDisable = [ "stackprotector" "fortify" ];
}
