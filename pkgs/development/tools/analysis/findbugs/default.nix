{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "findbugs-1.3.2";

  src = fetchurl {
    url = mirror://sourceforge/findbugs/findbugs-1.3.2.tar.gz;
    sha256 = "0mbwxzz5m9vizxlbg0i6rh5ywywiiw9zpabq5li7map43768apvr";
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
