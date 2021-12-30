{ lib, stdenv, fetchurl, perl, ncurses, ipbt, testVersion }:

stdenv.mkDerivation rec {
  version = "20210215.5a9cb02";
  pname = "ipbt";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-${version}.tar.gz";
    sha256 = "0w6blpv22jjivzr58y440zv6djvi5iccdmj4y2md52fbpjngmsha";
  };

  nativeBuildInputs = [ perl ];
  buildInputs = [ ncurses ];

  passthru.tests.version = testVersion { package = ipbt; };

  meta = with lib; {
    description = "A high-tech ttyrec player for Unix";
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/";
    license = licenses.mit;
    maintainers = [ maintainers.tckmn ];
    platforms = platforms.unix;
  };
}
