{ lib, stdenv, fetchurl, dpkg, jre_headless, nixosTests }:

let
  pname = "jicofo";
  version = "1.0-756";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/${pname}_${version}-1_all.deb";
    sha256 = "07qmxqp1llpn8kh590iz35zk17c2k4yg7i43nb2l0sfm40crpwfz";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  dontBuild = true;

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $src debcontents";

  installPhase = ''
    runHook preInstall
    substituteInPlace usr/share/jicofo/jicofo.sh \
      --replace "exec java" "exec ${jre_headless}/bin/java"

    mkdir -p $out/{share,bin}
    mv usr/share/jicofo $out/share/
    mv etc $out/
    cp ${./logging.properties-journal} $out/etc/jitsi/jicofo/logging.properties-journal
    ln -s $out/share/jicofo/jicofo.sh $out/bin/jicofo
    runHook postInstall
  '';

  passthru.tests = {
    single-node-smoke-test = nixosTests.jitsi-meet;
  };

  meta = with lib; {
    description = "A server side focus component used in Jitsi Meet conferences";
    longDescription = ''
      JItsi COnference FOcus is a server side focus component used in Jitsi Meet conferences.
    '';
    homepage = "https://github.com/jitsi/jicofo";
    license = licenses.asl20;
    maintainers = teams.jitsi.members;
    platforms = platforms.linux;
  };
}
