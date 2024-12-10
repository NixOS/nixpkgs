{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  jdk11_headless,
  makeWrapper,
  writeText,
  xorg,
}:

let
  xorgModulePaths = writeText "module-paths" ''
    Section "Files"
      ModulePath "${xorg.xorgserver}/lib/xorg/modules
      ModulePath "${xorg.xorgserver}/lib/xorg/extensions
      ModulePath "${xorg.xorgserver}/lib/xorg/drivers
      ModulePath "${xorg.xf86videodummy}/lib/xorg/modules/drivers
    EndSection
  '';

in
stdenv.mkDerivation rec {
  pname = "jibri";
  version = "8.0-169-g1258814";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/${pname}_${version}-1_all.deb";
    sha256 = "MAZJq2v25XQE6nbaAHSuxeoZOBwlOxCOIJkzxQVlKog=";
  };

  dontBuild = true;
  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/jitsi/jibri,etc/jitsi/jibri}
    mv etc/jitsi/jibri/* $out/etc/jitsi/jibri/
    mv opt/jitsi/jibri/* $out/opt/jitsi/jibri/

    cat '${xorgModulePaths}' >> $out/etc/jitsi/jibri/xorg-video-dummy.conf

    makeWrapper ${jdk11_headless}/bin/java $out/bin/jibri --add-flags "-jar $out/opt/jitsi/jibri/jibri.jar"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "JItsi BRoadcasting Infrastructure";
    mainProgram = "jibri";
    longDescription = ''
      Jibri provides services for recording or streaming a Jitsi Meet conference.
      It works by launching a Chrome instance rendered in a virtual framebuffer and capturing and
      encoding the output with ffmpeg. It is intended to be run on a separate machine (or a VM), with
      no other applications using the display or audio devices. Only one recording at a time is
      supported on a single jibri.
    '';
    homepage = "https://github.com/jitsi/jibri";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = teams.jitsi.members;
    platforms = platforms.linux;
  };
}
