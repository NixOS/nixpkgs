{lib, stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  pname = "emma";
  version = "2.0.5312";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.zip";
    sha256 = "0xxy39s2lvgs56vicjzpcz936l1vjaplliwa0dm7v3iyvw6jn7vj";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/lib/jars
    cp lib/*.jar $out/lib/jars/
  '';

  meta = {
    homepage = "https://emma.sourceforge.net/";
    description = "A code coverage tool for Java";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.unix;
    license = lib.licenses.cpl10;
  };
}
