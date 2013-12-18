{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "findbugs-2.0.3";

  src = fetchurl {
    url = mirror://sourceforge/findbugs/findbugs-2.0.3.tar.gz;
    sha256 = "17s93vszc5s2b7pwi0yk8d6w54gandxrr7vflhzmpbl6sxj2mfjr";
  };

  buildPhase = ''
    substituteInPlace bin/findbugs --replace /bin/pwd pwd
  '';

  installPhase = ''
    mkdir -p $out
    cp -prd bin lib plugin doc $out/
    rm $out/bin/*.bat
  '';

  meta = {
    description = "A static analysis tool to find bugs in Java programs automatically";
    homepage = http://findbugs.sourceforge.net/;
  };
}
