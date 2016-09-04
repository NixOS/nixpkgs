{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "emma-2.0.5312";
  
  src = fetchurl {
    url = mirror://sourceforge/emma/emma-2.0.5312.zip;
    sha256 = "0xxy39s2lvgs56vicjzpcz936l1vjaplliwa0dm7v3iyvw6jn7vj";
  };

  buildInputs = [unzip];

  installPhase = ''
    mkdir -p $out/lib/jars
    cp lib/*.jar $out/lib/jars/
  '';

  meta = {
    homepage = http://emma.sourceforge.net/;
    description = "A code coverage tool for Java";
    platforms = stdenv.lib.platforms.unix;
  };
}
