{ lib, stdenv, fetchurl, cmake
, curl, openssl, zlib
, libiconv
, version, sha256, ...
}:

with lib;

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

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    "-DMARIADB_UNIX_ADDR=/run/mysqld/mysqld.sock"
    "-DWITH_CURL=ON"
    "-DWITH_EXTERNAL_ZLIB=ON"
    "-DWITH_MYSQLCOMPAT=ON"
  ];

  postPatch = ''
    substituteInPlace mariadb_config/mariadb_config.c.in \
      --replace '-I%s/@INSTALL_INCLUDEDIR@' "-I$dev/include" \
      --replace '-L%s/@INSTALL_LIBDIR@' "-L$out/lib/mariadb"
  '';

  # The cmake setup-hook uses $out/lib by default, this is not the case here.
  preConfigure = optionalString stdenv.isDarwin ''
    cmakeFlagsArray+=("-DCMAKE_INSTALL_NAME_DIR=$out/lib/mariadb")
  '';

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ curl openssl zlib ];
  buildInputs = [ libiconv ];

  postInstall = ''
    moveToOutput bin/mariadb_config "$dev"
  '';

  postFixup = ''
    ln -sv mariadb_config $dev/bin/mysql_config
    ln -sv mariadb $out/lib/mysql
    ln -sv mariadb $dev/include/mysql
    ln -sv mariadb_version.h $dev/include/mariadb/mysql_version.h
    ln -sv libmariadb.pc $dev/lib/pkgconfig/mysqlclient.pc
  '';

  meta = {
    description = "Client library that can be used to connect to MySQL or MariaDB";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.all;
  };
}
