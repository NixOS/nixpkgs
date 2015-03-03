{ stdenv, fetchurl, unzip }:
let
  s = # Generated upstream information
  rec {
    baseName="zpaq";
    version="700";
    name="${baseName}-${version}";
    hash="1scn7xly1bmx3xr17mn32mqvpvpp53niryrqm7h0xkksmc623z9c";
    url="http://mattmahoney.net/dc/zpaq700.zip";
    sha256="1scn7xly1bmx3xr17mn32mqvpvpp53niryrqm7h0xkksmc623z9c";
  };
  buildInputs = [
    unzip
  ];
  isUnix = with stdenv; isLinux || isGNU || isDarwin || isFreeBSD || isOpenBSD;
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
	  g++ -O3 -march=native -Dunix libzpaq.cpp -pthread --shared -o libzpaq.so -fPIC
	  g++ -O3 -march=native -Dunix zpaq.cpp -lzpaq -L. -L"$out/lib" -pthread -o zpaq
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
