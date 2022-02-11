{ lib, stdenv, fetchurl, autoPatchelfHook, rpmextract, libX11, libXext }:

stdenv.mkDerivation rec {
  pname = "realvnc-vnc-viewer";
  version = "6.21.1109";

  src = {
    "x86_64-linux" = fetchurl {
      url = "https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-${version}-Linux-x64.rpm";
      sha256 = "12zxp9kvi070nzxbrnrfsyla38ryb69zlidw6cvypmsgqnylfxj7";
    };
    "i686-linux" = fetchurl {
      url = "https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-${version}-Linux-x86.rpm";
      sha256 = "03vhdmzyd16r0kdxpkq9azyy1h705lk4sbgnbw5fr8gkifwng60f";
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
    license = {
      fullName = "VNC Connect End User License Agreement";
      url = "https://static.realvnc.com/media/documents/LICENSE-4.0a_en.pdf";
      free = false;
    };
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
