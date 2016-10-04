{ stdenv, fetchurl, unzip }:
let
  s = # Generated upstream information
  rec {
    baseName="zpaqd";
    version="715";
    name="${baseName}-${version}";
    hash="0868lynb45lm79yvx5f10lj5h6bfv0yck8whcls2j080vmk3n7rk";
    url="http://mattmahoney.net/dc/zpaqd715.zip";
    sha256="0868lynb45lm79yvx5f10lj5h6bfv0yck8whcls2j080vmk3n7rk";
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
    description = "ZPAQ archive (de)compressor and algorithm development tool";
    license = licenses.gpl3Plus ;
    maintainers = with maintainers; [ raskin nckx ];
    platforms = platforms.linux;
  };
}
