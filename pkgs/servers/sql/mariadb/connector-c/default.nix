{ lib, stdenv, fetchFromGitHub, cmake
, curl, openssl, zlib, zstd
, libiconv
, version, hash, ...
}:

let
  isVer33 = lib.versionAtLeast version "3.3";

in stdenv.mkDerivation {
  pname = "mariadb-connector-c";
  inherit version;

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-c";
    rev = "v${version}";
    inherit hash;
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
      --replace '#define INCLUDE "-I%s/@INSTALL_INCLUDEDIR@ -I%s/@INSTALL_INCLUDEDIR@/mysql"' "#define INCLUDE \"-I$dev/include -I$dev/include/mysql\"" \
      --replace '#define LIBS    "-L%s/@INSTALL_LIBDIR@/ -lmariadb"' "#define LIBS    \"-L$out/lib/mariadb -lmariadb\"" \
      --replace '#define PKG_LIBDIR "%s/@INSTALL_LIBDIR@"' "#define PKG_LIBDIR \"$out/lib/mariadb\"" \
      --replace '#define PLUGIN_DIR "%s/@INSTALL_PLUGINDIR@"' "#define PLUGIN_DIR \"$out/lib/mariadb/plugin\"" \
      --replace '#define PKG_PLUGINDIR "%s/@INSTALL_PLUGINDIR@"' "#define PKG_PLUGINDIR \"$out/lib/mariadb/plugin\""
  '' + lib.optionalString stdenv.hostPlatform.isStatic ''
    # Disables all dynamic plugins
    substituteInPlace cmake/plugins.cmake \
      --replace 'if(''${CC_PLUGIN_DEFAULT} STREQUAL "DYNAMIC")' 'if(''${CC_PLUGIN_DEFAULT} STREQUAL "INVALID")'
    # Force building static libraries
    substituteInPlace libmariadb/CMakeLists.txt \
      --replace 'libmariadb SHARED' 'libmariadb STATIC'
  '';

  # The cmake setup-hook uses $out/lib by default, this is not the case here.
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cmakeFlagsArray+=("-DCMAKE_INSTALL_NAME_DIR=$out/lib/mariadb")
  '';

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ curl openssl zlib ] ++ lib.optional isVer33 zstd;
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
    install -Dm644 include/ma_config.h $dev/include/mariadb/my_config.h
  '';

  meta = with lib; {
    description = "Client library that can be used to connect to MySQL or MariaDB";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.all;
  };
}
