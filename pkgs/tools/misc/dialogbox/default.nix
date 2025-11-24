{
  stdenv,
  lib,
  mkDerivation,
  fetchFromGitHub,
  qmake,
  qtbase,
}:

mkDerivation rec {
  pname = "dialogbox";
  version = "1.0+unstable=2020-11-16";

  src = fetchFromGitHub {
    owner = "martynets";
    repo = pname;
    rev = "6989740746f376becc989ab2698e77d14186a0f9";
    hash = "sha256-paTas3KbV4yZ0ePnrOH1S3bLLHDddFml1h6b6azK4RQ=";
  };

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtbase
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/{bin,share/doc/dialogbox}
    install dist/dialogbox $out/bin
    install README.md $out/share/doc/dialogbox/
    cp -r demos $out/share/doc/dialogbox/demos

    runHook postInstall
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/martynets/dialogbox/";
    description = "Qt-based scriptable engine providing GUI dialog boxes";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "dialogbox";
  };
}
