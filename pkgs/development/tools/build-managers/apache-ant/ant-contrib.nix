args: with args;

stdenv.mkDerivation {
  name = "ant-contrib-1.0b3";

  installPhase = ''
    mkdir -p $out
    mv ant-contrib*.jar $out/
  '';

  phases = "unpackPhase installPhase";

  src = fetchurl {
    url = mirror://sourceforge/ant-contrib/ant-contrib-1.0b3-bin.tar.bz2;
    sha256 = "96effcca2581c1ab42a4828c770b48d54852edf9e71cefc9ed2ffd6590571ad1";
  };
}
