{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.3";
  pname = "httptunnel";

  src = fetchurl {
    url    = "http://www.nocrew.org/software/httptunnel/${pname}-${version}.tar.gz";
    sha256 = "0mn5s6p68n32xzadz6ds5i6bp44dyxzkq68r1yljlv470jr84bql";
  };

  meta = with lib; {
    description = "Creates a bidirectional virtual data connection tunnelled in HTTP requests";
    homepage    = "http://www.nocrew.org/software/httptunnel";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ koral ];
    platforms   = platforms.unix;
  };
}
