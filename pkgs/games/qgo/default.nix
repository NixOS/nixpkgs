{ stdenv, fetchFromGitHub, makeWrapper, qmake, qt56 }:

stdenv.mkDerivation rec {
  name = "qgo-${version}";
  version = "unstable-2016-06-23";

  meta = with stdenv.lib; {
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
    homepage = "https://github.com/pzorin/qgo";
    license = licenses.gpl2;
    maintainers = with maintainers; [ zalakain ];
  };

  src = fetchFromGitHub {
    owner = "pzorin";
    repo = "qgo";
    rev = "1e65b0c74914e534ea4d040f8f0ef8908383e374";
    sha256 = "1xzkayclmhsi07p9mnbf8185jw8n5ikxp2mik3x8qz1i6rmrfl5b";
  };

  patches = [ ./fix-paths.patch ];
  postPatch = ''
    sed -i 's|@out@|'"''${out}"'|g' src/src.pro src/defines.h
  '';
  nativeBuildInputs = [ makeWrapper qmake ];
  # qt58 does not provide platform plugins
  # We need lib/qt*/plugins/platforms/libqxcb.so
  buildInputs = with qt56; [ qtbase.out qtmultimedia qttranslations ];
  enableParallelBuilding = true;
  postFixup = ''
    # libQt5XcbQpa is a platform plugin dependency and doesn't get linked
    patchelf --add-needed libQt5XcbQpa.so.5 $out/bin/qgo
    wrapProgram $out/bin/qgo \
      --set QT_QPA_PLATFORM_PLUGIN_PATH "${qt56.qtbase}/lib/qt-5.6/plugins/platforms/"
  '';
}
