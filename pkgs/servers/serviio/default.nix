{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "serviio-${version}";
  version = "1.9";

  src = fetchurl {
    url = "http://download.serviio.org/releases/${name}-linux.tar.gz";
    sha256 = "0vi9dwpdrk087gpi0xib0hwpvdmaf9g99nfdfx2r3wmmdzw7wysl";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out
    cp -R config legal lib library plugins LICENCE.txt NOTICE.txt README.txt RELEASE_NOTES.txt $out
  '';

  meta = with stdenv.lib; {
    homepage = http://serviio.org;
    description = "UPnP Media Streaming Server";
    longDescription = ''
      Serviio is a free media server. It allows you to stream your media files (music, video or images)
      to any DLNA-certified renderer device (e.g. a TV set, Bluray player, games console) on your home network.
    '';
    license = licenses.unfree;
    maintainers = [ maintainers.thpham ];
    platforms = platforms.linux;
  };
}