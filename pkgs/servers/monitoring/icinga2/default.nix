{ stdenv, fetchFromGitHub, cmake, boost, yajl, openssl, flex, mysql, postgresql
, bison }:

stdenv.mkDerivation rec {
  name = "icinga2-${version}";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "icinga";
    repo = "icinga2";
    rev = "v${version}";
    sha256 = "1ilgwld1qg9nam0l3rx2ja1rnyamv90q76n4ndw9b51vsnff8qz9";
  };
  patches = [
    ./removemkdir.patch
  ];
  cmakeFlags = [
     "-DICINGA2_PLUGINDIR=plugins"
     "-DICINGA2_RUNDIR=/run"
     "-DICINGA2_SYSCONFDIR=/etc"
     "-DCMAKE_INSTALL_LOCALSTATEDIR=/var/lib/icinga2"
  ];

  MYSQL_INCLUDE_DIR="${mysql}/include/mysql";

  buildInputs = [ boost yajl openssl mysql postgresql ];
  nativeBuildInputs = [ cmake flex bison ];

  meta = with stdenv.lib; {
    description = "Open source monitoring system";
    homepage    = http://www.icinga.org;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ disassembler ];
  };
}
