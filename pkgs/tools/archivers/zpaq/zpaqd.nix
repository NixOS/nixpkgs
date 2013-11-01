{stdenv, fetchurl, unzip}:
let
  s = # Generated upstream information
  rec {
    baseName="zpaqd";
    version="633";
    name="${baseName}-${version}";
    hash="00zgc4mcmsd3d4afgzmrp6ymcyy8gb9kap815d5a3f9zhhzkz4dx";
    url="http://mattmahoney.net/dc/zpaqd633.zip";
    sha256="00zgc4mcmsd3d4afgzmrp6ymcyy8gb9kap815d5a3f9zhhzkz4dx";
  };
  buildInputs = [
    unzip
  ];
  isUnix = stdenv.isLinux || stdenv.isGNU || stdenv.isDarwin || stdenv.isBSD;
  isx86 = stdenv.isi686 || stdenv.isx86_64;
  compileFlags = ""
    + (stdenv.lib.optionalString isUnix " -Dunix -pthread ")
    + (stdenv.lib.optionalString (!isx86) " -DNOJIT ")
    + " -DNDEBUG "
    + " -fPIC "
    ;
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  sourceRoot = ".";
  buildPhase = ''
    g++ -shared -O3 libzpaq.cpp ${compileFlags} -o libzpaq.so
    g++ -O3 -L. -L"$out/lib" -lzpaq zpaqd.cpp -o zpaqd
  '';
  installPhase = ''
    mkdir -p "$out"/{bin,include,lib,share/doc/zpaq}
    cp libzpaq.so "$out/lib"
    cp zpaqd "$out/bin"
    cp libzpaq.h "$out/include"
    cp readme_zpaqd.txt "$out/share/doc/zpaq"
  '';
  meta = {
    inherit (s) version;
    description = ''ZPAQ archiver decompressor and algorithm development tool'';
    license = stdenv.lib.licenses.gpl3Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
