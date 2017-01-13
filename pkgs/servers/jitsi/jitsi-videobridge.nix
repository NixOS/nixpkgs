{ pkgs, stdenv, lib, fetchurl, makeWrapper, ... }:

stdenv.mkDerivation rec {
  name = "jitsi-videobridge-${rev}";
  version = "751";
  rev = "${version}-1";
  arch = "amd64";

  src = fetchurl {
    url = "https://download.jitsi.org/jitsi/debian/jitsi-videobridge_${rev}_${arch}.deb";
    sha256 = "0xy42xfpxmxhc2fmzz7k0k8l46xhjaz3yazn2pr4nksr91w6pkgz";
  };

  dontBuild = true;
  doCheck = false;

  unpackCmd = "ar x $curSrc && tar -xvf data.tar.xz";
  sourceRoot = "./";

  installPhase = ''
    mkdir -p $out/etc $out/bin
    mv etc/jitsi $out/etc/
    mv usr/share $out/
    cd $out/share
    ln -s jitsi-videobridge java
    cd $out/bin
    ln -s ../share/jitsi-videobridge/jvb.sh jitsi-videobridge
  '';

  meta = with stdenv.lib; {
    description = "Jitsi Videobridge is an XMPP server component that allows for multiuser video communication.";
    longDescription = ''
      Jitsi Videobridge is an XMPP server component that allows for multiuser video communication. Unlike the expensive dedicated hardware videobridges, Jitsi Videobridge does not mix the video channels into a composite video stream, but only relays the received video channels to all call participants. Therefore, while it does need to run on a server with good network bandwidth, CPU horsepower is not that critical for performance.
    '';
    homepage = https://github.com/jitsi/jitsi-videobridge;
    license = licenses.asl20;
    maintainers = with maintainers; [ oida ];
    platforms = platforms.linux;
  };
}
