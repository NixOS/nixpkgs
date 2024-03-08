{ lib
, stdenv
, windows
, fetchurl
, autoreconfHook
}:

let
  version = "11.0.1";
in stdenv.mkDerivation {
  pname = "mingw-w64";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    hash = "sha256-P2a84Gnui+10OaGhPafLkaXmfqYXDyExesf1eUYl7hA=";
  };

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

  meta = {
    platforms = lib.platforms.windows;
  };
}
