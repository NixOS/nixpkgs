{ stdenv, fetchzip, autoreconfHook, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "bgpdump-2017-09-29";

  src = fetchzip {
    url = "https://bitbucket.org/ripencc/bgpdump/get/94a0e724b335.zip";
    sha256 = "09g9vz2zc4nyzl669w1j7fxw21ifja6dxbp0xbqh6n7w3gpx2g88";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib bzip2 ];

  meta = {
    homepage = https://bitbucket.org/ripencc/bgpdump/wiki/Home;
    description = ''Analyze dump files produced by Zebra/Quagga or MRT'';
    license = stdenv.lib.licenses.hpnd;
    maintainers = with stdenv.lib.maintainers; [ lewo ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
