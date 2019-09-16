{ stdenv, fetchFromGitHub, cmake, pkgconfig
, boost, bison, curl, ncurses, openssl, xxd
, libaio, libev, libgcrypt, libgpgerror, libtool, zlib
}:

stdenv.mkDerivation rec {
  pname = "percona-xtrabackup";
  version = "2.4.12";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "percona-xtrabackup";
    rev = "${pname}-${version}";
    sha256 = "1w17v2c677b3vfnm81bs63kjbfiin7f12wl9fbgp83hfpyx5msan";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    boost bison curl ncurses openssl xxd
    libaio libev libgcrypt libgpgerror libtool zlib
  ];

  cmakeFlags = [
    "-DBUILD_CONFIG=xtrabackup_release"
    "-DINSTALL_MYSQLTESTDIR=OFF"
    "-DWITH_BOOST=system"
    "-DWITH_SSL=system"
    "-DWITH_ZLIB=system"
    "-DWITH_MAN_PAGES=OFF"
    "-DCMAKE_CXX_FLAGS=-std=gnu++03"
  ];

  postInstall = ''
    rm -r "$out"/lib/plugin/debug
  '';

  meta = with stdenv.lib; {
    description = "Non-blocking backup tool for MySQL";
    homepage = http://www.percona.com/software/percona-xtrabackup;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
  };
}
