{stdenv, fetchurl, zlib, gnutls}:

stdenv.mkDerivation {
  name = "rtmpdump-2.2d";
  src = fetchurl {
    url = http://rtmpdump.mplayerhq.hu/download/rtmpdump-2.2d.tgz;
    sha256 = "0w2cr3mgp4dcabmr7d7pnsn8f2r1zvar553vfavnzqv61gnhyrm5";
  };

  buildInputs = [ zlib gnutls ];

  makeFlags = "CRYPTO=GNUTLS posix";

  installPhase = ''
    ensureDir $out/bin $out/share/man/man{1,8}
    cp rtmpdump rtmpsrv rtmpsuck rtmpgw $out/bin
    cp *.1 $out/share/man/man1
    cp *.8 $out/share/man/man8
  '';

  meta = {
    homepage = http://rtmpdump.mplayerhq.hu/;
    description = "Toolkit for RTMP streams";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
