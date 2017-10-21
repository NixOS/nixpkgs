{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "schedtool-1.3.0";

  src = fetchurl {
    url = "http://freequaos.host.sk/schedtool/${name}.tar.bz2";
    sha256 = "1ky8q3jg4lsxbnlmm51q3jkxh160zy0l6a4xkdy2yncxc4m2l02f";
  };

  makeFlags = [ "DESTDIR=$(out)" "DESTPREFIX=" ];

  meta = with stdenv.lib; {
    description = "Query or alter a process' scheduling policy under Linux";
    homepage = http://freequaos.host.sk/schedtool/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
