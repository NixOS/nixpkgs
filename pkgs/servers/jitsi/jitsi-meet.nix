{ pkgs, stdenv, lib, fetchurl, config }:

stdenv.mkDerivation rec {
  name = "jitsi-meet-${rev}";
  version = "1.0.1073";
  rev = "${version}-1";
  arch = "all";

  src = fetchurl {
    url = "https://download.jitsi.org/jitsi/debian/jitsi-meet_${rev}_${arch}.deb";
    sha256 = "1pl8qjn6n1x6nzjsfh4yngbd3a6r2j06v29w4n8shs7lll11l0wg";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  unpackCmd = "ar x $curSrc && tar -xvf data.tar.xz";
  sourceRoot = "./";

  installPhase = ''
    mkdir -p $out/etc $out/var
    mv etc/jitsi $out/etc/
    mv usr/share $out/
    ln -s /run/jitsi-meet/config.js $out/share/jitsi-meet/config.js
    cd $out/var
    ln -s ../share/jitsi-meet www
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Jitsi Meet - Secure, Simple and Scalable Video Conferences https://jitsi.org/Projects/JitsiMeet";
    longDescription = ''
      Jitsi Meet is an open-source (Apache) WebRTC JavaScript application that uses Jitsi Videobridge to provide high quality, scalable video conferences. You can see Jitsi Meet in action here at the session #482 of the VoIP Users Conference.
      You can also try it out yourself at https://meet.jit.si .
      Jitsi Meet allows for very efficient collaboration. It allows users to stream their desktop or only some windows. It also supports shared document editing with Etherpad.
    '';
    homepage = https://github.com/jitsi/jitsi-meet;
    license = licenses.asl20;
    maintainers = with maintainers; [ oida ];
    platforms = platforms.linux;
  };
}
