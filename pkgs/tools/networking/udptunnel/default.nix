{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "udptunnel-19";

  src = fetchurl {
    url = http://udptunnel.googlecode.com/files/udptunnel-r19.tar.gz;
    sha1 = "51edec3b63b659229bcf92f6157568d3b074ede0";
  };

  installPhase = ''
    mkdir -p $out/bin $out/share/udptunnel
    cp udptunnel $out/bin
    cp README COPYING* $out/share/udptunnel
  '';

  meta = {
    homepage = http://code.google.com/p/udptunnel/;
    description = "Tunnels TCP over UDP packets";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
