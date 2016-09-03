{stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "redo-1.2";
  src = fetchurl {
    url = "https://jdebp.eu./Repository/freebsd/${name}.tar.gz";
    sha256 = "0qr8plllxfn32r4rgnalzlhcs3b4l8a4ga8ig9v8i5iy1qnfhqnf";
  };

  nativeBuildInputs = [ perl /* for pod2man */ ];

  sourceRoot = ".";

  buildPhase = ''
    ./package/compile
  '';
  installPhase = ''
    ./package/export $out/
  '';

  meta = {
    homepage = https://jdebp.eu./Softwares/redo/;
    description = "A system for building target files from source files";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.vrthra ];
    platforms = stdenv.lib.platforms.unix;
  };
}
