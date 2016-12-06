{ pkgs, stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "jicofo-${rev}";
  version = "1.0";
  rev = "${version}-267-1";
  arch = "amd64";

  src = fetchurl {
    url = "https://download.jitsi.org/jitsi/debian/jicofo_${rev}_${arch}.deb";
    sha256 = "0b6wwav860x78n82knmhmf08jk36ygg65rdwfha7hdgkpjkdy6wr";
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
    ln -s jicofo java
    cd $out/bin
    ln -s ../share/jicofo/jicofo.sh jicofo
  '';


  meta = with stdenv.lib; {
    description = "JItsi COnference FOcus is a server side focus component used in Jitsi Meet conferences.";
    longDescription = ''
      Conference focus is mandatory component of Jitsi Meet conferencing system next to the videobridge. It is responsible for managing media sessions between each of the participants and the videobridge. Whenever new conference is about to start an IQ is sent to the component to allocate new focus instance. After that special focus participant joins Multi User Chat room. It will be creating Jingle session between Jitsi videobridge and the participant. Although the session in terms of XMPP is between focus user and participant the media will flow between participant and the videobridge. That's because focus user will allocate Colibri channels on the bridge and use them as it's own Jingle transport.
    '';
    homepage = https://github.com/jitsi/jicofo;
    license = licenses.asl20;
    maintainers = with maintainers; [ oida ];
    platforms = platforms.linux;
  };
}
