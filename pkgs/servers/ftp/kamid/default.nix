{ stdenv
, lib
, pkg-config
, libevent
, libressl
, libbsd
, fetchurl
, readline
}:

stdenv.mkDerivation rec {
  pname = "kamid";
  version = "0.1";

  src = fetchurl {
    url = "https://github.com/omar-polo/kamid/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "16gi82dgaxwy8fgg05hbam796pk51i6xlyrx8qhghi7ikxr5jd19";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libevent
    libressl
    readline
    libbsd
  ];

  meta = with lib; {
    description = "A FREE, easy-to-use and portable implementation of a 9p file server daemon for UNIX-like systems";
    homepage = "https://kamid.omarpolo.com";
    license = licenses.isc;
    maintainers = with maintainers; [ heph2 ];
    platforms = platforms.unix;
  };
}
