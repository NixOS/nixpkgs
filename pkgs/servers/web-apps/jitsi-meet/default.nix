{ lib, stdenv, fetchurl, fetchFromGitHub, nixosTests }:

let
  # Maintainers: refer to https://github.com/jitsi/jitsi-meet-release-notes/blob/master/CHANGELOG-WEB.md
  # When you rev this, also update the passthru.src below.
  meetVersion = "6854";
in
stdenv.mkDerivation rec {
  pname = "jitsi-meet";
  version = "1.0.${meetVersion}";

  src = fetchurl {
    url = "https://download.jitsi.org/jitsi-meet/src/jitsi-meet-${version}.tar.bz2";
    sha256 = "BOGghB1drxe241+Zk1p/DHjEAuTNyiMEx8c3lDERwP4=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv * $out/
    runHook postInstall
  '';

  passthru.tests = {
    single-host-smoke-test = nixosTests.jitsi-meet;
  };

  passthru = {
    updateScript = ./update.sh;

    # Prosody depends on this to pull in Jitsi Meet plugins. Ensure that you update this SHA256
    # when you rev meetVersion so Prosody rebuilds, as the backend plugins are not bundled
    # in the build tarball from download.jitsi.org.
    src = fetchFromGitHub {
      repo = "jitsi-meet";
      owner = "jitsi";
      rev = meetVersion;
      sha256 = "XaSXqD9uQTCuiaVW8TUVcsStWuJoGxFqVI7N5/Aq5eg=";
    };
  };

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
  };
}
