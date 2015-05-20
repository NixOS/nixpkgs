{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "ttylog-0.25";

  src = fetchurl {
    url = "mirror://sourceforge/ttylog/${name}.tar.gz";
    sha256 = "0546mj5gcxi7idvfw82p8qw27lk7wsk6j4b6zw7nb6z2wi517l40";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = "http://ttylog.sourceforg.net";
    description = "a serial port logger which can be used to print everything to stdout that comes from a serial device";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
