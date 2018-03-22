{stdenv, fetchurl, ant, unzip}:

stdenv.mkDerivation rec {
  name = "mysql-connector-java-5.1.45";
  builder = ./builder.sh;

  src = fetchurl {
    url = "http://dev.mysql.com/get/Downloads/Connector-J/${name}.zip";
    sha256 = "1x3dygygj15p7zk825mqr0g80wlm3rfsqgbqnb11l133rk4s1ylw";
  };

  buildInputs = [ unzip ant ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
