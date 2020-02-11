{ stdenv, fetchFromGitHub, cmake, pkgconfig, glibc
, bison, curl, flex, gperftools, jansson, jemalloc, kerberos, lua, libmysqlclient
, ncurses, openssl, pcre, pcre2, perl, rabbitmq-c, sqlite, tcl
, libaio, libedit, libtool, libui, libuuid, zlib
}:

stdenv.mkDerivation rec {
  pname = "maxscale";
  version = "2.1.17";

  src = fetchFromGitHub {
    owner = "mariadb-corporation";
    repo = "MaxScale";
    rev = "${pname}-${version}";
    sha256 = "161kc6aqqj3z509q4qwvsd86h06hlyzdask4gawn2ij0h3ca58q6";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    bison curl flex gperftools jansson jemalloc kerberos lua libmysqlclient
    ncurses openssl pcre pcre2 perl rabbitmq-c sqlite tcl
    libaio libedit libtool libui libuuid zlib
  ];

  patches = [ ./getopt.patch ];

  preConfigure = ''
    for i in `grep -l -R '#include <getopt.h>' .`; do
      substituteInPlace $i --replace "#include <getopt.h>" "#include <${glibc.dev}/include/getopt.h>"
    done
 '';

  cmakeFlags = [
    "-DUSE_C99=YES"
    "-DDEFAULT_ADMIN_USER=root"
    "-DWITH_MAXSCALE_CNF=YES"
    "-DSTATIC_EMBEDDED=YES"
    "-DBUILD_RABBITMQ=YES"
    "-DBUILD_BINLOG=YES"
    "-DBUILD_CDC=NO"
    "-DBUILD_MMMON=YES"
    "-DBUILD_LUAFILTER=YES"
    "-DLUA_LIBRARIES=${lua}/lib"
    "-DLUA_INCLUDE_DIR=${lua}/include"
    "-DGCOV=NO"
    "-DWITH_SCRIPTS=OFF"
    "-DBUILD_TESTS=NO"
    "-DBUILD_TOOLS=NO"
    "-DPROFILE=NO"
    "-DWITH_TCMALLOC=YES"
    "-DWITH_JEMALLOC=YES"
    "-DINSTALL_EXPERIMENTAL=YES"
    "-DTARGET_COMPONENT=all"
  ];

  CFLAGS = "-std=gnu99";

  enableParallelBuilding = false;

  dontStrip = true;

  postInstall = ''
    find $out/bin -type f -perm -0100 | while read f1; do
      patchelf \
        --set-rpath "$(patchelf --print-rpath $f1):${libmysqlclient}/lib/mariadb:$out/lib/maxscale" \
        --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" $f1 \
        && patchelf --shrink-rpath $f1
    done

    find $out/lib/maxscale -type f -perm -0100 | while read f2; do
      patchelf \
        --set-rpath "$(patchelf --print-rpath $f2)":$out/lib/maxscale $f2
    done

    mv $out/share/maxscale/create_grants $out/bin
    rm -rf $out/{etc,var}
  '';

  meta = with stdenv.lib; {
     description = ''MaxScale database proxy extends MariaDB Server's high availability'';
     homepage = https://mariadb.com/products/technology/maxscale;
     license = licenses.bsl11;
     platforms = platforms.linux;
     maintainers = with maintainers; [ izorkin ];
 };
}
