{ stdenv, fetchurl, ant, jdk }:

let version = "9.3-1100"; in

stdenv.mkDerivation rec {
  name = "postgresql-jdbc-${version}";

  src = fetchurl {
    url = "http://jdbc.postgresql.org/download/postgresql-jdbc-${version}.src.tar.gz";
    sha256 = "0mbdzhzg4ws0i7ps98rg0q5n68lsrdm2klj7y7skaix0rpa57gp6";
  };

  buildInputs = [ ant jdk ];

  buildPhase = "ant";

  installPhase =
    ''
      mkdir -p $out/share/java
      cp jars/*.jar $out/share/java
    '';

  meta = with stdenv.lib; {
    homepage = http://jdbc.postgresql.org/;
    description = "JDBC driver for PostgreSQL allowing Java programs to connect to a PostgreSQL database";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
