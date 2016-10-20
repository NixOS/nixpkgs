{ stdenv, fetchFromGitHub, autoreconfHook, zlib, pkgconfig, libuuid }:

stdenv.mkDerivation rec{
  version = "1.4.0";
  name = "netdata-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "firehol";
    repo = "netdata";
    sha256 = "1wknxci2baj6f7rl8z8j7haaz122jmbb74aw7i3xbj2y61cs58n8";
  };

  buildInputs = [ autoreconfHook zlib pkgconfig libuuid ];

  preConfigure = ''
    export ZLIB_CFLAGS=" "
    export ZLIB_LIBS="-lz"
    export UUID_CFLAGS=" "
    export UUID_LIBS="-luuid"
  '';

  meta = with stdenv.lib; {
    description = "Real-time performance monitoring tool";
    homepage = http://netdata.firehol.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };

}
