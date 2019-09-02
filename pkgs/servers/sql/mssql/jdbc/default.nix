{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "mssql-jdbc";
  version = "7.2.2";
  builder = ./builder.sh;

  src = fetchurl {
    url = "https://github.com/Microsoft/mssql-jdbc/releases/download/v${version}/${pname}-${version}.jre8.jar";
    sha256 = "09psxjy1v3khq8lcq6h9mbgyijsgawf0z2qryk1l91ypnwl8s3pg";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
