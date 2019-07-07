{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "serviio-${version}";
  version = "1.10.1";

  src = fetchurl {
    url = "http://download.serviio.org/releases/${name}-linux.tar.gz";
    sha256 = "0gxa29mzwvr0xvvi2qizyvf68ma5s3405q58f1pcgadbb68jwx6q";
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