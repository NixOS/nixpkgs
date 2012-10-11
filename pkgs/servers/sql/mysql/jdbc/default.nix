{stdenv, fetchurl, ant, unzip}:

stdenv.mkDerivation {
  name = "mysql-connector-java-5.1.22";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-5.1.22.zip;
    sha256 = "0hfx1znq0iqclkc8visca7x67lvlk3cswni69ghi2c5cpa2d4ijm";
  };

  buildInputs = [ unzip ant ];
}
