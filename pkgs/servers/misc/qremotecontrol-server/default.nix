{ lib
, stdenv
, fetchgit
, qmake
, wrapQtAppsHook
, qtbase
, xorg
}:

stdenv.mkDerivation rec {
  pname = "qremotecontrol-server";
  version = "unstable-2014-11-05"; # basically 2.4.2 + qt5

  src = fetchgit {
    url = "https://git.code.sf.net/p/qrc/gitcode";
    rev = "8f1c55eac10ac8af974c3c20157d90ef57f7308a";
    sha256 = "sha256-AfFScec5/emG/f+yc5Zn37USIEWzGP/sBifE6Kx8d0E=";
  };

  patches = [
    ./0001-fix-qt5-build-include-QDataStream.patch
  ];

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    xorg.libXtst
  ];

  postPatch = ''
    substituteInPlace QRemoteControl-Server.pro \
      --replace /usr $out
  '';

  meta = with lib; {
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
    homepage = "https://sourceforge.net/projects/qrc/";
    description = "Remote control your desktop from your mobile";
    longDescription = ''
      With QRemoteControl installed on your desktop you can easily control
      your computer via WiFi from your mobile. By using the touch pad of your
      Phone you can for example open the internet browser and navigate to
      the pages you want to visit, use the music player or your media center
      without being next to your PC or laptop. Summarizing QRemoteControl
      allows you to do almost everything you would be able to do with a
      mouse and a keyboard, but from a greater distance. To make these
      replacements possible QRemoteControl offers you a touch pad, a
      keyboard, multimedia keys and buttons for starting applications. Even
      powering on the computer via Wake On Lan is supported.
    '';
  };
}
