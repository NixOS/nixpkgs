{ lib, stdenv, fetchurl, autoPatchelfHook, rpmextract, libX11, libXext }:

stdenv.mkDerivation rec {
  pname = "realvnc-vnc-viewer";
  version = "6.21.406";

  src = {
    "x86_64-linux" = fetchurl {
      url = "https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-${version}-Linux-x64.rpm";
      sha256 = "0rnizzanaykqg1vfy56p8abc4fmgpbibj54j4c1v81zsj3kmahka";
    };
    "i686-linux" = fetchurl {
      url = "https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-${version}-Linux-x86.rpm";
      sha256 = "1rlxfiqymi1licn2spyiqa00kiwzhdr0pkh7vv3ai6gb9f6phk31";
    };
  }.${stdenv.system};

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
    maintainers = with maintainers; [ angustrau ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
