{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "serviio";
  version = "2.0";

  src = fetchurl {
    url = "http://download.serviio.org/releases/${pname}-${version}-linux.tar.gz";
    sha256 = "1zq1ax0pdxfn0nw0vm7s23ik47w8nwh1n83a7yka8dnknxjf5nng";
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