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

  dontBuild = true;
  doCheck = false;

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

  meta = with stdenv.lib; {
    description = "Jitsi Meet - Secure, Simple and Scalable Video Conferences https://jitsi.org/Projects/JitsiMeet";
    longDescription = ''
      Jitsi Meet allows for very efficient collaboration. It allows users to stream their desktop or only some windows. It also supports shared document editing with Etherpad.
    '';
    homepage = https://github.com/jitsi/jitsi-meet;
    license = licenses.asl20;
    maintainers = with maintainers; [ oida ];
    platforms = platforms.linux;
  };
}
