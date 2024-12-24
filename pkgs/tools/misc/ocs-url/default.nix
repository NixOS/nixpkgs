{
  lib,
  stdenv,
  fetchgit,
  libsForQt5,
}:

let
  version = "3.1.0";

  main_src = fetchgit {
    url = "https://www.opencode.net/dfn2/ocs-url.git";
    rev = "release-${version}";
    sha256 = "RvbkcSj8iUAHAEOyETwfH+3XnCCY/p8XM8LgVrZxrws=";
  };

  qtil_src = fetchgit {
    url = "https://github.com/akiraohgaki/qtil";
    rev = "v0.4.0";
    sha256 = "XRSp0F7ggfkof1RNAnQU3+O9DcXDy81VR7NakITOXrw=";
  };
in

stdenv.mkDerivation rec {
  pname = "ocs-url";
  inherit version;

  srcs = [
    main_src
    qtil_src
  ];
  sourceRoot = main_src.name;

  # We are NOT in $sourceRoot here
  postUnpack = ''
    mkdir -p $sourceRoot/lib/qtil
    cp -r ${qtil_src.name}/* $sourceRoot/lib/qtil/
  '';

  buildInputs = with libsForQt5.qt5; [
    qtbase
    qtsvg
    qtquickcontrols
    qmake
    wrapQtAppsHook
  ];

  meta = with lib; {
    description = "Open Collaboration System for use with DE store websites";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ SohamG ];
    platforms = platforms.linux;
    mainProgram = "ocs-url";
  };
}
