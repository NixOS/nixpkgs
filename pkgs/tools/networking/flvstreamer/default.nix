{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "flvstreamer";
  version = "2.1c1";

  src = fetchurl {
    url = "mirror://savannah/flvstreamer/source/flvstreamer-${version}.tar.gz";
    sha256 = "e90e24e13a48c57b1be01e41c9a7ec41f59953cdb862b50cf3e667429394d1ee";
  };

  buildPhase = ''
    make CC=${stdenv.cc.targetPrefix}cc posix
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp flvstreamer $out/bin
    cp streams $out/bin
    cp rtmpsrv $out/bin
    cp rtmpsuck $out/bin
  '';

  meta = {
    description = "Command-line RTMP client";

    longDescription = ''
      flvstreamer is an open source command-line RTMP client intended to
              stream audio or video content from all types of flash or rtmp servers.
    '';

    license = lib.licenses.gpl2Plus;

    homepage = "https://savannah.nongnu.org/projects/flvstreamer";

    maintainers = [ lib.maintainers.thammers ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
