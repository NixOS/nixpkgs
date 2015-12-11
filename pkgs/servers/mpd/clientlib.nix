{ stdenv, fetchurl, doxygen }:

stdenv.mkDerivation rec {
  version = "${passthru.majorVersion}.${passthru.minorVersion}";
  name = "libmpdclient-${version}";

  src = fetchurl {
    url = "http://www.musicpd.org/download/libmpdclient/2/${name}.tar.xz";
    sha256 = "10pzs9z815a8hgbbbiliapyiw82bnplsccj5irgqjw5f5plcs22g";
  };

  buildInputs = [ doxygen ];

  passthru = {
    majorVersion = "2";
    minorVersion = "10";
  };

  meta = with stdenv.lib; {
    description = "Client library for MPD (music player daemon)";
    homepage = http://www.musicpd.org/libs/libmpdclient/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mornfall ehmry ];
  };
}
