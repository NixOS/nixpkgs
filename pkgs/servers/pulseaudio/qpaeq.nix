{
  mkDerivation,
  makeDesktopItem,
  python3,
  lib,
  pulseaudio,
}:

let
  desktopItem = makeDesktopItem {
    name = "qpaeq";
    exec = "@out@/bin/qpaeq";
    icon = "audio-volume-high";
    desktopName = "qpaeq";
    genericName = "Audio equalizer";
    categories = [
      "AudioVideo"
      "Audio"
      "Mixer"
    ];
    startupNotify = false;
  };
in
mkDerivation {
  pname = "qpaeq";
  inherit (pulseaudio) version src;

  buildInputs = [

    (python3.withPackages (
      ps: with ps; [
        pyqt5
        dbus-python
      ]
    ))

  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    install -D ./src/utils/qpaeq $out/bin/qpaeq
    install -D ${desktopItem}/share/applications/qpaeq.desktop $out/share/applications/qpaeq.desktop
    runHook postInstall
  '';

  preFixup = ''
    sed "s|,sip|,PyQt5.sip|g" -i $out/bin/qpaeq
    wrapQtApp $out/bin/qpaeq
    sed "s|@out@|$out|g" -i $out/share/applications/qpaeq.desktop
  '';

  meta = {
    description = "Equalizer interface for pulseaudio's equalizer sinks";
    mainProgram = "qpaeq";
    homepage = "http://www.pulseaudio.org/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;
  };
}
