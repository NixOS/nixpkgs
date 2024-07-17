{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  dpkg,
  jre_headless,
  openssl,
  nixosTests,
}:

let
  pname = "jitsi-videobridge2";
  version = "2.3-105-ge155b81e";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/${pname}_${version}-1_all.deb";
    sha256 = "jQTZwnj1oECjUTD8dC6PF5tJcPye8FYUJmYEEBhBuRs=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  dontBuild = true;

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $src debcontents";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    substituteInPlace usr/share/jitsi-videobridge/jvb.sh \
      --replace "exec java" "exec ${jre_headless}/bin/java"

    mkdir -p $out/{bin,share/jitsi-videobridge,etc/jitsi/videobridge}
    mv etc/jitsi/videobridge/logging.properties $out/etc/jitsi/videobridge/
    cp ${./logging.properties-journal} $out/etc/jitsi/videobridge/logging.properties-journal
    mv usr/share/jitsi-videobridge/* $out/share/jitsi-videobridge/
    ln -s $out/share/jitsi-videobridge/jvb.sh $out/bin/jitsi-videobridge

    # - work around https://github.com/jitsi/jitsi-videobridge/issues/1547
    # - make libcrypto.so available at runtime for hardware AES
    wrapProgram $out/bin/jitsi-videobridge \
      --set VIDEOBRIDGE_GC_TYPE G1GC \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl ]}
    runHook postInstall
  '';

  passthru.tests = {
    single-host-smoke-test = nixosTests.jitsi-meet;
  };

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A WebRTC compatible video router";
    longDescription = ''
      Jitsi Videobridge is an XMPP server component that allows for multiuser video communication.
      Unlike the expensive dedicated hardware videobridges, Jitsi Videobridge does not mix the video
      channels into a composite video stream, but only relays the received video channels to all call
      participants. Therefore, while it does need to run on a server with good network bandwidth,
      CPU horsepower is not that critical for performance.
    '';
    homepage = "https://github.com/jitsi/jitsi-videobridge";
    license = licenses.asl20;
    maintainers = teams.jitsi.members;
    platforms = platforms.linux;
    mainProgram = "jitsi-videobridge";
  };
}
