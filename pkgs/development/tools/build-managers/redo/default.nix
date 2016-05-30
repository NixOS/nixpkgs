{stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "redo-1.2";
  src = fetchurl {
    url = "http://homepage.ntlworld.com/jonathan.deboynepollard/Softwares/${name}.tar.bz2";
    sha256 = "0hfbiljmgl821a0sf7abrfx29f22ahrgs86mrlrm8m95s7387kpp";
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
    homepage = http://homepage.ntlworld.com/jonathan.deboynepollard/Softwares/redo.html;
    description = "A system for building target files from source files";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.vrthra ];
    platforms = stdenv.lib.platforms.unix;
  };
}
