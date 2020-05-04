{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "midicsv-1.1";

  src = fetchurl {
    url = "http://www.fourmilab.ch/webtools/midicsv/${name}.tar.gz";
    sha256 = "1vvhk2nf9ilfw0wchmxy8l13hbw9cnpz079nsx5srsy4nnd78nkw";
  };

  postPatch = ''
    substituteInPlace Makefile --replace /usr/local $out
  '';

  meta = with stdenv.lib; {
    description = "Losslessly translate MIDI to CSV and back";
    homepage = "http://www.fourmilab.ch/webtools/midicsv/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
