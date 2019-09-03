{ stdenv, fetchurl, openssl, libpcap
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "cowpatty";
  version = "4.6";

  buildInputs = [ openssl libpcap ];

  src = fetchurl {
    url = "http://www.willhackforsushi.com/code/cowpatty/${version}/${pname}-${version}.tgz";
    sha256 = "1hivh3bq2maxvqzwfw06fr7h8bbpvxzah6mpibh3wb85wl9w2gyd";
  };

  installPhase = "make DESTDIR=$out BINDIR=/bin install";

  meta = {
    description = "Offline dictionary attack against WPA/WPA2 networks";
    license = licenses.gpl2;
    homepage = https://www.willhackforsushi.com/?page_id=50;
    maintainers = with maintainers; [ nico202 ];
    platforms = platforms.linux;
  };
}
