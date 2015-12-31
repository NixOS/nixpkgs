{ stdenv, fetchurl, unzip }:
let
  s = # Generated upstream information
  rec {
    baseName="zpaq";
    version="705";
    name="${baseName}-${version}";
    hash="0d1knq4f6693nvbwjx4wznb45hm4zyn4k88xvhynyk0dcbiy7ayq";
    url="http://mattmahoney.net/dc/zpaq705.zip";
    sha256="0d1knq4f6693nvbwjx4wznb45hm4zyn4k88xvhynyk0dcbiy7ayq";
  };
  buildInputs = [
    unzip
  ];
  isUnix = with stdenv; isLinux || isGNU || isDarwin || isFreeBSD || isOpenBSD;
  isx86 = stdenv.isi686 || stdenv.isx86_64;
  compileFlags = with stdenv; ""
    + (lib.optionalString (isUnix) " -Dunix -pthread")
    + (lib.optionalString (isi686) " -march=i686")
    + (lib.optionalString (isx86_64) " -march=nocona")
    + (lib.optionalString (!isx86) " -DNOJIT")
    + " -O3 -mtune=generic -DNDEBUG"
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
    g++ ${compileFlags} -fPIC --shared libzpaq.cpp -o libzpaq.so
    g++ ${compileFlags} -L. -L"$out/lib" -lzpaq zpaq.cpp -o zpaq
  '';
  installPhase = ''
    mkdir -p "$out"/{bin,include,lib,share/doc/zpaq}
    cp libzpaq.so "$out/lib"
    cp zpaq "$out/bin"
    cp libzpaq.h "$out/include"
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
