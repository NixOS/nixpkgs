{stdenv, fetchurl, ant}:

stdenv.mkDerivation {
  name = "postgresql-jdbc-8.2";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://jdbc.postgresql.org/download/postgresql-jdbc-8.2-504.src.tar.gz;
    sha256 = "1fkza5j4b9pzm69cw1zv35bqk062d92l4l0zhz3qn0g64r08ccm4";
  };

  buildInputs = [ant];
}
