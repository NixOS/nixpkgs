{lib, stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  pname = "jtds";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/jtds/${version}/${pname}-${version}-dist.zip";
    sha256 = "sha256-eV0P8QdjfuHXzYssH8yHhynuH0Clg7MAece2Up3S9M0";
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/java
    cp jtds-*.jar $out/share/java/jtds-jdbc.jar
  '';

  nativeBuildInputs = [ unzip ];

  meta = with lib; {
    description = "Pure Java (type 4) JDBC 3.0 driver for Microsoft SQL Server";
    homepage = "https://jtds.sourceforge.net/";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
