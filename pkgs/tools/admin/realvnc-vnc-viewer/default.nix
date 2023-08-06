{ lib
, stdenv
, callPackage
}:
let
  pname = "realvnc-vnc-viewer";
  version = "7.5.1";

  meta = with lib; {
    description = "VNC remote desktop client software by RealVNC";
    homepage = "https://www.realvnc.com/en/connect/download/viewer/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = {
      fullName = "VNC Connect End User License Agreement";
      url = "https://static.realvnc.com/media/documents/LICENSE-4.0a_en.pdf";
      free = false;
    };
    maintainers = with maintainers; [ emilytrau onedragon ];
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
in
if stdenv.isDarwin then callPackage ./darwin.nix { inherit pname version meta; }
else callPackage ./linux.nix { inherit pname version meta; }
