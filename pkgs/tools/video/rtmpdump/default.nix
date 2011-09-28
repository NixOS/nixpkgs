{stdenv, fetchgit, zlib, gnutls, libgcrypt}:

stdenv.mkDerivation {
  name = "rtmpdump-2.4";
  src = fetchgit {
    url = git://git.ffmpeg.org/rtmpdump;
    rev = "c28f1bab7822de97353849e7787b59e50bbb1428";
    sha256 = "927e7ea7a686adb7cbce9d0a0c710de1e0921bbb1f0c1b35d17bdb816e6c73d8";
  };

  buildInputs = [ zlib gnutls libgcrypt ];

  makeFlags = "CRYPTO=GNUTLS";

  configurePhase = ''
    sed -i s,/usr/local,$out, Makefile librtmp/Makefile
  '';

  meta = {
    homepage = http://rtmpdump.mplayerhq.hu/;
    description = "Toolkit for RTMP streams";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
