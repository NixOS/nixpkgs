{ stdenv, fetchurl, autoPatchelfHook, patchelf, xorg, lib }:

stdenv.mkDerivation rec {
  name = "vncviewer";
  src = fetchurl {
    url = "https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-6.21.406-Linux-x64";
    sha256 = "c34178d4f29a8968feecf4dc1bd5d9449a53a227197a28a31aa6ed9f64cb99cc";
  };

  dontUnpack = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ xorg.libX11 xorg.libXext ];

  installPhase = ''
    install -m755 -D ${src} $out/bin/vncviewer
  '';

  meta = with lib; {
    homepage = "https://www.realvnc.com/en/connect/download/viewer/";
    description = "VNCViewer";
    maintainers = with maintainers; [ imalison ];
  };
}
