{ lib
, stdenv
, fetchFromGitHub
, cmake
, makeWrapper
, pkg-config
, SDL2
, dbus
, libdecor
, libnotify
, dejavu_fonts
, gnome
}:

let
  inherit (gnome) zenity;
in

stdenv.mkDerivation rec {
  pname = "trigger-control";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "Etaash-mathamsetty";
    repo = "trigger-control";
    rev = "v.${version}";
    hash = "sha256-wueNjrCPWDw7iCOuXgzWZiweRc3o6SUw3xZGgm078nM=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    SDL2
    dbus
    libnotify
  ] ++ lib.optionals stdenv.isLinux [
    libdecor
  ];

  # The app crashes without a changed fontdir and upstream recommends dejavu as font
  postPatch = ''
    substituteInPlace trigger-control.cpp --replace "/usr/share/fonts/" "${dejavu_fonts}/share/fonts/"
  '';

  installPhase = ''
    runHook preInstall

    install -D trigger-control $out/bin/trigger-control

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/trigger-control \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '';

  meta = with lib; {
    description = "Control the dualsense's triggers on Linux (and Windows) with a gui and C++ api";
    homepage = "https://github.com/Etaash-mathamsetty/trigger-control";
    license = licenses.mit;
    maintainers = with maintainers; [ azuwis ];
    platforms = platforms.all;
  };
}
