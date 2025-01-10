{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
  olm,
}:

stdenv.mkDerivation rec {
  pname = "jitsi-meet";
  version = "1.0.8043";

  src = fetchurl {
    url = "https://download.jitsi.org/jitsi-meet/src/jitsi-meet-${version}.tar.bz2";
    sha256 = "XJlfCMQXnHjfHQhK916RXsdPzrU2U2IaOMiXIHL1sCI=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv * $out/
    runHook postInstall
  '';

  # Test requires running Jitsi Videobridge and Jicofo which are Linux-only
  passthru.tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    single-host-smoke-test = nixosTests.jitsi-meet;
  };

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Secure, Simple and Scalable Video Conferences";
    longDescription = ''
      Jitsi Meet is an open-source (Apache) WebRTC JavaScript application that uses Jitsi Videobridge
      to provide high quality, secure and scalable video conferences.
    '';
    homepage = "https://github.com/jitsi/jitsi-meet";
    license = licenses.asl20;
    maintainers = teams.jitsi.members;
    platforms = platforms.all;
    inherit (olm.meta) knownVulnerabilities;
  };
}
