{ stdenv, fetchurl, cmake
, curl, openssl, zlib
, libiconv
, version, sha256, ...
}:

with stdenv.lib;

stdenv.mkDerivation {
  pname = "mariadb-connector-c";
  inherit version;

  src = fetchurl {
    urls = [
      "https://downloads.mariadb.org/f/connector-c-${version}/mariadb-connector-c-${version}-src.tar.gz"
      "https://downloads.mariadb.com/Connectors/c/connector-c-${version}/mariadb-connector-c-${version}-src.tar.gz"
    ];
    inherit sha256;
  };

  cmakeFlags = [
    "-DMARIADB_UNIX_ADDR=/run/mysqld/mysqld.sock"
    "-DWITH_CURL=ON"
    "-DWITH_EXTERNAL_ZLIB=ON"
    "-DWITH_MYSQLCOMPAT=ON"
  ];

  # The cmake setup-hook uses $out/lib by default, this is not the case here.
  preConfigure = optionalString stdenv.isDarwin ''
    cmakeFlagsArray+=("-DCMAKE_INSTALL_NAME_DIR=$out/lib/mariadb")
  '';

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ curl openssl zlib ];
  buildInputs = [ libiconv ];

  enableParallelBuilding = true;

  postFixup = ''
    ln -sv mariadb_config $out/bin/mysql_config
    ln -sv mariadb $out/lib/mysql
    ln -sv mariadb $out/include/mysql
    ln -sv mariadb_version.h $out/include/mariadb/mysql_version.h
    ln -sv libmariadb.pc $out/lib/pkgconfig/mysqlclient.pc
  '';

  meta = {
    description = "Client library that can be used to connect to MySQL or MariaDB";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.all;
  };
}
