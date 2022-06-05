{ mkDerivation, lib, fetchFromGitLab, qtbase, qtserialport, cmake }:

mkDerivation rec {
  pname = "cutecom";
  version = "0.51.0+patch";

  src = fetchFromGitLab {
    owner = "cutecom";
    repo = "cutecom";
    rev = "70d0c497acf8f298374052b2956bcf142ed5f6ca";
    sha256 = "X8jeESt+x5PxK3rTNC1h1Tpvue2WH09QRnG2g1eMoEE=";
  };

  buildInputs = [ qtbase qtserialport ];
  nativeBuildInputs = [ cmake ];

  postInstall = ''
    cd ..
    mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps,man/man1}
    cp cutecom.desktop "$out/share/applications"
    cp images/cutecom.svg "$out/share/icons/hicolor/scalable/apps"
    cp cutecom.1 "$out/share/man/man1"
  '';

  meta = with lib; {
    description = "A graphical serial terminal";
    homepage = "https://gitlab.com/cutecom/cutecom/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bennofs ];
    platforms = platforms.linux;
  };
}
