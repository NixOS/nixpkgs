{ lib, stdenv, windows, fetchurl }:

let
  version = "10.0.0";

  knownArches = [ "32" "64" "arm32" "arm64" ];
  enabledArch =
    if stdenv.targetPlatform.isAarch32
    then "arm32"
    else if stdenv.targetPlatform.isAarch64
    then "arm64"
    else if stdenv.targetPlatform.isx86_32
    then "32"
    else if stdenv.targetPlatform.isx86_64
    then "64"
    else null;
  archFlags =
    if enabledArch == null
    then [] # maybe autoconf will save us
    else map (arch: lib.enableFeature (arch == enabledArch) "lib${arch}") knownArches;

  crt = stdenv.hostPlatform.libc;
in stdenv.mkDerivation {
  pname = "mingw-w64";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    sha256 = "sha256-umtDCu1yxjo3aFMfaj/8Kw/eLFejslFFDc9ImolPCJQ=";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--enable-idl"
    "--enable-secure-api"
    "--with-default-msvcrt=${crt}"
  ] ++ archFlags;

  enableParallelBuilding = true;

  buildInputs = [ windows.mingw_w64_headers ];
  dontStrip = true;
  hardeningDisable = [ "stackprotector" "fortify" ];

  meta = {
    platforms = lib.platforms.windows;
    broken = !(lib.elem crt [ "msvcrt" "ucrt" ]);
  };
}
