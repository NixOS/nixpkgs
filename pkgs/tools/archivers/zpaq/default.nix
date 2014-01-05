{stdenv, fetchurl, unzip}:
let
  s = # Generated upstream information
  rec {
    baseName="zpaq";
    version="643";
    name="${baseName}-${version}";
    hash="1sgrhvvzrjb9gm9lffs1ai602v8p1mav0kc2sa7wlcx7kj1d3hxr";
    url="http://mattmahoney.net/dc/zpaq643.zip";
    sha256="1sgrhvvzrjb9gm9lffs1ai602v8p1mav0kc2sa7wlcx7kj1d3hxr";
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
    g++ -O3 -L. -L"$out/lib" -lzpaq divsufsort.c zpaq.cpp -o zpaq
  '';
  installPhase = ''
    mkdir -p "$out"/{bin,include,lib,share/doc/zpaq}
    cp libzpaq.so "$out/lib"
    cp zpaq "$out/bin"
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
