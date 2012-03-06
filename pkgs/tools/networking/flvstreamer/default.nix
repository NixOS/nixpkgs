{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "flvstreamer-2.1c1";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/flvstreamer/source/${name}.tar.gz";
    sha256 = "e90e24e13a48c57b1be01e41c9a7ec41f59953cdb862b50cf3e667429394d1ee";
  };

  buildPhase = ''
    make posix
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp flvstreamer $out/bin
    cp streams $out/bin
    cp rtmpsrv $out/bin
    cp rtmpsuck $out/bin
  '';

  meta = {
    description = "flvstreamer is an command-line RTMP client";

    longDescription =
      '' flvstreamer is an open source command-line RTMP client intended to 
         stream audio or video content from all types of flash or rtmp servers.
      '';

    license = "GPLv2+";

    homepage = http://savannah.nongnu.org/projects/flvstreamer;

    maintainers = [ stdenv.lib.maintainers.thammers ];
    platforms = stdenv.lib.platforms.linux;
  };
}
