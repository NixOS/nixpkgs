{ stdenv, fetchurl, ant }:

stdenv.mkDerivation rec {
  name = "postgresql-jdbc-9.1-902";
  builder = ./builder.sh;

  src = fetchurl {
    url = "http://jdbc.postgresql.org/download/${name}.src.tar.gz";
    sha256 = "0sgwbiw5vfxcl0g1yzsndgxdha74cr8ag6y65i0jhgg5g8qc56bz";
  };

  buildInputs = [ant];

  meta = {
    homepage = http://jdbc.postgresql.org/;
    description = "JDBC driver for PostgreSQL allowing Java programs to connect to a PostgreSQL database";
    license = "bsd";
  };
}
