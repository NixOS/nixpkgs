{ stdenv
, lib
, dpkg
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, webkitgtk
, libsoup
, openssl_1_1
}:

stdenv.mkDerivation rec {
  name = "en-croissant";
  version = "0.7.1";

  src = fetchurl {
    url = "https://github.com/franciscoBSalgueiro/en-croissant/releases/download/v${version}/en-croissant_${version}_amd64.deb";
    sha256 = "1lrl0pg0aihx87yqygfailbf9n9ra1l0a7zg40j36c92h8k0zmcb";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    openssl_1_1
    libsoup
    webkitgtk
    wrapGAppsHook
  ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = "mv usr $out";

  meta = with lib; {
    description = "A Modern Chess Database";
    homepage = "https://github.com/franciscoBSalgueiro/en-croissant/";
    maintainers = [ maintainers.lcscosta ];
    license = licenses.gpl3;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    mainProgram = "en-croissant";
  };
}
