{ lib
, stdenv
, fetchgit
, qmake4Hook
, qt4
, xorg
}:

stdenv.mkDerivation rec {
  pname = "qremotecontrol-server";
  version = "2.4.2";

  # There is no 2.4.2 release tarball, but there is a git tag
  src = fetchgit {
    url = "https://git.code.sf.net/p/qrc/gitcode";
    rev = version;
    sha256 = "sha256-i3X575SbrWV8kWWHAhXvKl5aSKFZm0VyrJOiL7eYrCo=";
  };

  nativeBuildInputs = [ qmake4Hook ];
  buildInputs = [ qt4 xorg.libXtst ];

  postPatch = ''
    substituteInPlace QRemoteControl-Server.pro \
      --replace /usr $out
  '';

  meta = with lib; {
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
    homepage = "https://qremote.org/";
    downloadPage = "https://qremote.org/download.php#Download";
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

