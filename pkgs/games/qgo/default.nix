{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtbase
, qtmultimedia
, qttranslations
}:

mkDerivation {
  pname = "qgo";
  version = "unstable-2017-12-18";

  meta = with lib; {
    description = "A Go client based on Qt5";
    longDescription = ''
      qGo is a Go Client based on Qt 5. It supports playing online at
      IGS-compatible servers (including some special tweaks for WING and LGS,
      also NNGS was reported to work) and locally against gnugo (or other
      GTP-compliant engines). It also has rudimentary support for editing SGF
      files and parital support for CyberORO/WBaduk, Tygem, Tom, and eWeiqi
      (developers of these backends are currently inactive, everybody is welcome
      to take them over).

      Go is an ancient Chinese board game. It's called "圍棋(Wei Qi)" in
      Chinese, "囲碁(Yi Go)" in Japanese, "바둑(Baduk)" in Korean.
    '';
    homepage = https://github.com/pzorin/qgo;
    license = licenses.gpl2;
    maintainers = with maintainers; [ zalakain ];
  };

  src = fetchFromGitHub {
    owner = "pzorin";
    repo = "qgo";
    rev = "bef526dda4c79686edd95c88cc68de24f716703c";
    sha256 = "1xzkayclmhsi07p9mnbf8185jw8n5ikxp2mik3x8qz1i6rmrfl5b";
  };

  patches = [ ./fix-paths.patch ];
  postPatch = ''
    sed -i 's|@out@|'"''${out}"'|g' src/src.pro src/defines.h
  '';
  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtmultimedia qttranslations ];
  enableParallelBuilding = true;

}
