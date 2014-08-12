{stdenv, fetchgit, zlib, gnutls, libgcrypt}:

stdenv.mkDerivation {
  name = "rtmpdump-2.4";
  src = fetchgit {
    url = git://git.ffmpeg.org/rtmpdump;
    rev = "79459a2b43f41ac44a2ec001139bcb7b1b8f7497";
    sha256 = "5af22362004566794035f989879b13d721f85d313d752abd10a7e45806e3944c";
  };

  buildInputs = [ zlib gnutls libgcrypt ];

  makeFlags = "CRYPTO=GNUTLS";

  configurePhase = ''
    sed -i s,/usr/local,$out, Makefile librtmp/Makefile
  '';

  meta = {
    homepage = http://rtmpdump.mplayerhq.hu/;
    description = "Toolkit for RTMP streams";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers. viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
