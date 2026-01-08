{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  curl,
  openssl,
  zlib,
  zstd,
  libiconv,
  version,
  hash,
  ...
}:

let
  isVer33 = lib.versionAtLeast version "3.3";

in
stdenv.mkDerivation {
  pname = "mariadb-connector-c";
  inherit version;

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "mariadb-connector-c";
    rev = "v${version}";
    inherit hash;
  };

  patches = lib.optionals (lib.versionOlder version "3.4") [
    # fix compilation against gcc15
    (fetchpatch {
      url = "https://github.com/mariadb-corporation/mariadb-connector-c/commit/e8448137f3365568090d5c0d4051039ddc1cdb6f.patch";
      hash = "sha256-aDbaaJA8DxGG5RrOa+CHhk4wuzlBy5tWyS+f/zVYU0c=";
    })

    # Fix the build with CMake 4.
    (fetchpatch {
      name = "mariadb-connector-c-fix-cmake-4.patch";
      url = "https://github.com/mariadb-corporation/mariadb-connector-c/commit/598dc3d2d7a63e5d250421dd0ea88be55ea8511f.patch";
      hash = "sha256-HojNRobguBmtpEdr2lVi/MpcoDAsZnb3+tw/pt376es=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    "-DMARIADB_UNIX_ADDR=/run/mysqld/mysqld.sock"
    "-DWITH_CURL=ON"
    "-DWITH_EXTERNAL_ZLIB=ON"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isMinGW) [
    "-DWITH_MYSQLCOMPAT=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    # MSYS2 mingw-w64-libmariadbclient builds these plugins STATIC to avoid relocation issues
    # and to keep the build working with MinGW toolchains.
    "-DWITH_MYSQLCOMPAT=OFF"
    "-DWITH_SSL=SCHANNEL"
    "-DWITH_UNIT_TESTS=OFF"
    "-DCLIENT_PLUGIN_AUTH_GSSAPI_CLIENT=STATIC"
    "-DCLIENT_PLUGIN_DIALOG=STATIC"
    "-DCLIENT_PLUGIN_REMOTE_IO=STATIC"
    "-DCLIENT_PLUGIN_PVIO_NPIPE=STATIC"
    "-DCLIENT_PLUGIN_PVIO_SHMEM=STATIC"
    "-DCLIENT_PLUGIN_CLIENT_ED25519=STATIC"
    "-DCLIENT_PLUGIN_CACHING_SHA2_PASSWORD=STATIC"
    "-DCLIENT_PLUGIN_SHA256_PASSWORD=STATIC"
    "-DCLIENT_PLUGIN_MYSQL_CLEAR_PASSWORD=STATIC"
    "-DCLIENT_PLUGIN_MYSQL_OLD_PASSWORD=STATIC"
    "-DCLIENT_PLUGIN_ZSTD=STATIC"
  ];

  postPatch = ''
    substituteInPlace mariadb_config/mariadb_config.c.in \
      --replace-fail '#define INCLUDE "-I%s/@INSTALL_INCLUDEDIR@ -I%s/@INSTALL_INCLUDEDIR@/mysql"' "#define INCLUDE \"-I$dev/include -I$dev/include/mysql\"" \
      --replace-fail '#define LIBS    "-L%s/@INSTALL_LIBDIR@/ -lmariadb"' "#define LIBS    \"-L$out/lib/mariadb -lmariadb\"" \
      --replace-fail '#define PKG_LIBDIR "%s/@INSTALL_LIBDIR@"' "#define PKG_LIBDIR \"$out/lib/mariadb\"" \
      --replace-fail '#define PLUGIN_DIR "%s/@INSTALL_PLUGINDIR@"' "#define PLUGIN_DIR \"$out/lib/mariadb/plugin\"" \
      --replace-fail '#define PKG_PLUGINDIR "%s/@INSTALL_PLUGINDIR@"' "#define PKG_PLUGINDIR \"$out/lib/mariadb/plugin\""
  ''
  + lib.optionalString stdenv.hostPlatform.isMinGW ''
    # MinGW: strerror_r is not available; use strerror_s instead.
    substituteInPlace libmariadb/ma_net.c \
      --replace-fail "strerror_r(save_errno, errmsg, 100);" "strerror_s(errmsg, 100, save_errno);"
  ''
  + lib.optionalString stdenv.hostPlatform.isStatic ''
    # Disables all dynamic plugins
    substituteInPlace cmake/plugins.cmake \
      --replace-fail 'if(''${CC_PLUGIN_DEFAULT} STREQUAL "DYNAMIC")' 'if(''${CC_PLUGIN_DEFAULT} STREQUAL "INVALID")'
    # Force building static libraries
    substituteInPlace libmariadb/CMakeLists.txt \
      --replace-fail 'libmariadb SHARED' 'libmariadb STATIC'
  '';

  # The cmake setup-hook uses $out/lib by default, this is not the case here.
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cmakeFlagsArray+=("-DCMAKE_INSTALL_NAME_DIR=$out/lib/mariadb")
  '';

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [
    curl
    openssl
    zlib
  ]
  ++ lib.optional isVer33 zstd;
  buildInputs = [ libiconv ];

  postInstall = ''
    moveToOutput "bin/mariadb_config${stdenv.hostPlatform.extensions.executable}" "$dev"
  '';

  postFixup = ''
    mkdir -p $dev/bin
    ln -sv "mariadb_config${stdenv.hostPlatform.extensions.executable}" "$dev/bin/mysql_config${stdenv.hostPlatform.extensions.executable}"
    ln -sv mariadb $out/lib/mysql
    ln -sv mariadb $dev/include/mysql
    ln -sv mariadb_version.h $dev/include/mariadb/mysql_version.h
    ln -sv libmariadb.pc $dev/lib/pkgconfig/mysqlclient.pc
    install -Dm644 include/ma_config.h $dev/include/mariadb/my_config.h
  ''
  + lib.optionalString stdenv.hostPlatform.isMinGW ''
    # Qt's FindMySQL.cmake looks for MySQL client libraries by conventional names
    # (e.g. libmysqlclient.dll.a / libmysqlclient_r.dll.a). MSYS2 provides these by
    # copying/aliasing MariaDB connector libs; do the same so cross-configuration can
    # find MySQL_LIBRARY.
    if [ -d "$out/lib/mariadb" ]; then
      imp_src=""
      static_src=""

      # Import library name differs across toolchains/buildsystems.
      for cand in libmariadb.dll.a liblibmariadb.dll.a; do
        if [ -e "$out/lib/mariadb/$cand" ]; then
          imp_src="$cand"
          break
        fi
      done

      # Static client library name also varies.
      for cand in libmariadbclient.a libmariadb.a; do
        if [ -e "$out/lib/mariadb/$cand" ]; then
          static_src="$cand"
          break
        fi
      done

      if [ -n "$imp_src" ]; then
        ln -sf "$imp_src" "$out/lib/mariadb/libmysqlclient.dll.a"
        ln -sf "$imp_src" "$out/lib/mariadb/libmysqlclient_r.dll.a"
        # Also provide top-level libdir aliases so CMake's find_library() can locate them
        # without knowing about the /lib/mariadb subdirectory.
        mkdir -p "$out/lib"
        ln -sf "mariadb/libmysqlclient.dll.a" "$out/lib/libmysqlclient.dll.a"
        ln -sf "mariadb/libmysqlclient_r.dll.a" "$out/lib/libmysqlclient_r.dll.a"
      fi

      if [ -n "$static_src" ]; then
        ln -sf "$static_src" "$out/lib/mariadb/libmysqlclient.a"
        ln -sf "$static_src" "$out/lib/mariadb/libmysqlclient_r.a"
        mkdir -p "$out/lib"
        ln -sf "mariadb/libmysqlclient.a" "$out/lib/libmysqlclient.a"
        ln -sf "mariadb/libmysqlclient_r.a" "$out/lib/libmysqlclient_r.a"
      fi
    fi
  '';

  meta = {
    description = "Client library that can be used to connect to MySQL or MariaDB";
    homepage = "https://github.com/mariadb-corporation/mariadb-connector-c";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
