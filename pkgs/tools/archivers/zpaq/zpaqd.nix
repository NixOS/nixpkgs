{ stdenv, fetchurl, unzip }:
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

  src = fetchurl {
    inherit (s) url sha256;
  };

  sourceRoot = ".";

  buildInputs = [ unzip ];

  buildPhase = ''
    g++ ${compileFlags} -fPIC --shared libzpaq.cpp -o libzpaq.so
    g++ ${compileFlags} -L. -L"$out/lib" -lzpaq zpaqd.cpp -o zpaqd
  '';

  installPhase = ''
    mkdir -p "$out"/{bin,include,lib,share/doc/zpaq}
    cp libzpaq.so "$out/lib"
    cp zpaqd "$out/bin"
    cp libzpaq.h "$out/include"
    cp readme_zpaqd.txt "$out/share/doc/zpaq"
  '';

  meta = with stdenv.lib; {
    inherit (s) version;
    description = "ZPAQ archive (de)compressor and algorithm development tool";
    license = licenses.gpl3Plus ;
    maintainers = with maintainers; [ raskin nckx ];
    platforms = platforms.linux;
  };
}
