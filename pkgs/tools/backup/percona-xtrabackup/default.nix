{ stdenv, fetchFromGitHub, cmake, pkgconfig
, boost, bison, curl, ncurses, openssl, readline, xxd
, libaio, libev, libgcrypt, libgpgerror, libtool, zlib
}:

stdenv.mkDerivation rec {
  name = "percona-xtrabackup-${version}";
  version = "2.4.9";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "percona-xtrabackup";
    rev = name;
    sha256 = "11w87wj2jasrnygzjg3b59q9x0m6lhyg1wzdvclmgbmqsk9bvqv4";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    boost bison curl ncurses openssl readline xxd
    libaio libev libgcrypt libgpgerror libtool zlib
  ];

  cmakeFlags = [
    "-DBUILD_CONFIG=xtrabackup_release"
    "-DINSTALL_MYSQLTESTDIR=OFF"
    "-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock"
    "-DWITH_SSL=system"
    "-DWITH_ZLIB=system"
    "-DWITH_MECAB=system"
    "-DWITH_EXTRA_CHARSETS=all"
    "-DWITH_INNODB_MEMCACHED=1"
    "-DWITH_MAN_PAGES=OFF"
    "-DWITH_HTML_DOCS=OFF"
    "-DWITH_LATEX_DOCS=OFF"
    "-DWITH_PDF_DOCS=OFF"
  ];

  meta = with stdenv.lib; {
    description = "Non-blocking backup tool for MySQL";
    homepage = http://www.percona.com/software/percona-xtrabackup;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
  };
}
