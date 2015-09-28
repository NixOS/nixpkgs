{ stdenv, fetchzip, qt4, sqlite, cmake }:

stdenv.mkDerivation rec {
  version = "3.7.0";
  name = "sqlitebrowser-${version}";

  src = fetchzip {
    name = "${name}-src";
    url = "https://github.com/sqlitebrowser/sqlitebrowser/archive/v${version}.tar.gz";
    sha256 = "1zsgylnxk4lyg7p6k6pv8d3mh1k0wkfcplh5c5da3x3i9a3qs78j";
  };

  buildInputs = [ qt4 sqlite cmake ];

  meta = with stdenv.lib; {
    description = "DB Browser for SQLite";
    homepage = "http://sqlitebrowser.org/";
    license = licenses.gpl3;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux; # can only test on linux
  };
}

