{ stdenv, fetchurl, unzip }:

let
  # Generated upstream information
  s = rec {
    baseName="zpaqd";
    version="715";
    name="${baseName}-${version}";
    hash="0868lynb45lm79yvx5f10lj5h6bfv0yck8whcls2j080vmk3n7rk";
    url="http://mattmahoney.net/dc/zpaqd715.zip";
    sha256="0868lynb45lm79yvx5f10lj5h6bfv0yck8whcls2j080vmk3n7rk";
  };

  compileFlags = stdenv.lib.concatStringsSep " " ([ "-O3" "-mtune=generic" "-DNDEBUG" ]
    ++ stdenv.lib.optional (stdenv.hostPlatform.isUnix) "-Dunix -pthread"
    ++ stdenv.lib.optional (stdenv.hostPlatform.isi686) "-march=i686"
    ++ stdenv.lib.optional (stdenv.hostPlatform.isx86_64) "-march=nocona"
    ++ stdenv.lib.optional (!stdenv.hostPlatform.isx86) "-DNOJIT");
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
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
