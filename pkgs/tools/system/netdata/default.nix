{ stdenv, fetchFromGitHub, autoreconfHook, zlib, pkgconfig }:

stdenv.mkDerivation rec{
  version = "1.0.0";
  name = "netdata-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "firehol";
    repo = "netdata";
    sha256 = "03107ny98zks05p44jzypkk4lw8lbvmqja5b537ln6cnrgp20yvq";
  };

  buildInputs = [ autoreconfHook zlib pkgconfig ];

  patches = [ ./web_access.patch ];

  meta = with stdenv.lib; {
    description = "Real-time performance monitoring tool";
    homepage = http://netdata.firehol.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };

}
