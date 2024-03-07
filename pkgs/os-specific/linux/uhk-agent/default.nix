{ lib
, stdenvNoCC
, fetchurl
, appimageTools
, electron
, makeWrapper
, asar
, autoPatchelfHook
, libusb1
}:

let
  pname = "uhk-agent";
  version = "3.2.2";

  src = fetchurl {
    url = "https://github.com/UltimateHackingKeyboard/agent/releases/download/v${version}/UHK.Agent-${version}-linux-x86_64.AppImage";
    name = "${pname}-${version}.AppImage";
    sha256 = "sha256-0kNcpdYktgzIPVvfSitJ5aIuhJvCEcbubumHhW00QUE=";
  };

  appimageContents = appimageTools.extract {
    name = "${pname}-${version}";
    inherit src;
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  dontUnpack = true;

  nativeBuildInputs = [
    asar
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    libusb1
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{opt,share/applications}

    cp -r --no-preserve=mode "${appimageContents}/resources"        "$out/opt/${pname}"
    cp -r --no-preserve=mode "${appimageContents}/usr/share/icons"  "$out/share/icons"
    cp -r --no-preserve=mode "${appimageContents}/${pname}.desktop" "$out/share/applications/${pname}.desktop"

    substituteInPlace "$out/share/applications/${pname}.desktop" \
      --replace "Exec=AppRun" "Exec=${pname}"

    asar extract "$out/opt/${pname}/app.asar" "$out/opt/${pname}/app.asar.unpacked"
    rm           "$out/opt/${pname}/app.asar"

    makeWrapper "${electron}/bin/electron" "$out/bin/${pname}" \
      --add-flags "$out/opt/${pname}/app.asar.unpacked" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  meta = with lib; {
    description = "Agent is the configuration application of the Ultimate Hacking Keyboard";
    homepage = "https://github.com/UltimateHackingKeyboard/agent";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ ngiger nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
