{stdenv, fetchurl, unzip}:
let
  s = # Generated upstream information
  rec {
    baseName="zpaq";
    version="622";
    name="${baseName}-${version}";
    hash="19avac9spq5kgcgbixd9kvjhy9j0ga75izwqhif44h3jlzdydsmc";
    url="http://mattmahoney.net/dc/zpaq622.zip";
    sha256="19avac9spq5kgcgbixd9kvjhy9j0ga75izwqhif44h3jlzdydsmc";
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
    g++ -shared -O3 libzpaq.cpp divsufsort.c ${compileFlags} -o libzpaq.so
    g++ -O3 -L. -L"$out/lib" -lzpaq zpaq.cpp -o zpaq
    g++ -O3 -L. -L"$out/lib" -lzpaq zpaqd.cpp -o zpaqd
  '';
  installPhase = ''
    mkdir -p "$out"/{bin,include,lib,share/doc/zpaq}
    cp libzpaq.so "$out/lib"
    cp zpaq zpaqd "$out/bin"
    cp libzpaq.h divsufsort.h "$out/include"
    cp readme.txt "$out/share/doc/zpaq"
  '';
  meta = {
    inherit (s) version;
    description = ''An archiver with backward compatibility of versions for decompression'';
    license = stdenv.lib.licenses.gpl3Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://mattmahoney.net/dc/zpaq.html";
  };
}
