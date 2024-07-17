{
  lib,
  stdenv,
  fetchzip,
  libusb1,
  cups,
  dpkg,
  libjpeg8,
  makeWrapper,
  autoPatchelfHook,
  enablePtqpdf ? false, # Pantum's version of qpdf
}:

let
  architecture =
    {
      i686-linux = "i386";
      x86_64-linux = "amd64";
    }
    .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "pantum-driver";
  version = "1.1.106";

  src = fetchzip {
    url = "https://drivers.pantum.com/userfiles/files/download/drive/Pantum%20Ubuntu%20Driver%20V1_1_106.zip";
    hash = "sha256-FzR/wC73dJ4+rqFT+JvTduxzcozJIAs6jADNbmJby+M=";
  };

  buildInputs = [
    libusb1
    libjpeg8
    cups
  ];
  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  installPhase =
    ''
      dpkg-deb -x ./Resources/pantum_${version}-1_${architecture}.deb .

      mkdir -p $out $out/lib
      cp -r etc $out/
      cp -r usr/lib/cups $out/lib/
      cp -r usr/local/lib/* $out/lib/
      cp -r usr/share $out/
      cp Resources/locale/en_US.UTF-8/* $out/share/doc/pantum/
    ''
    + lib.optionalString enablePtqpdf ''
      cp -r opt/pantum/* $out/
      ln -s $out/lib/libqpdf.so* $out/lib/libqpdf.so
      ln -s $out/lib/libqpdf.so $out/lib/libqpdf.so.21
    '';

  meta = with lib; {
    description = "Pantum universal driver";
    homepage = "https://global.pantum.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ deinferno ];
  };
}
