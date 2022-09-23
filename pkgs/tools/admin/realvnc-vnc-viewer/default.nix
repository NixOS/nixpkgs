{ lib, stdenv, fetchurl, autoPatchelfHook, rpmextract, libX11, libXext }:

stdenv.mkDerivation rec {
  pname = "realvnc-vnc-viewer";
  version = "6.22.515";

  src = {
    "x86_64-linux" = fetchurl {
      url = "https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-${version}-Linux-x64.rpm";
      sha256 = "1l9kfmb1695pv2v9hm8z5yr7y5yhadbbs61s4yf9ksvvfypzwrpn";
    };
    "i686-linux" = fetchurl {
      url = "https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-${version}-Linux-x86.rpm";
      sha256 = "15fi1siwbsxmy7qi6f8r8ym346a8mx3kqcp9mvwvx39wm3ija6dh";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook rpmextract ];
  buildInputs = [ libX11 libXext ];

  unpackPhase = ''
    rpmextract $src
  '';

  postPatch = ''
    substituteInPlace ./usr/share/applications/realvnc-vncviewer.desktop \
      --replace /usr/share/icons/hicolor/48x48/apps/vncviewer48x48.png vncviewer48x48.png
    substituteInPlace ./usr/share/mimelnk/application/realvnc-vncviewer-mime.desktop \
      --replace /usr/share/icons/hicolor/48x48/apps/vncviewer48x48.png vncviewer48x48.png
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "VNC remote desktop client software by RealVNC";
    homepage = "https://www.realvnc.com/en/connect/download/viewer/";
    mainProgram = "vncviewer";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = {
      fullName = "VNC Connect End User License Agreement";
      url = "https://static.realvnc.com/media/documents/LICENSE-4.0a_en.pdf";
      free = false;
    };
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
