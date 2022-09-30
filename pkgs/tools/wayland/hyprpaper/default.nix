{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libjpeg
, mesa
, pango
, wayland
, wayland-protocols
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "hyprpaper";
  version = "unstable-2022-07-24";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = pname;
    rev = "f75fcf01d1f652d55f79032a40d821d2ff78520e";
    sha256 = "sha256-M2g4NeDoYt32j02cimCR4vWzAzauIzQVQaWgBWXDAtk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libjpeg
    mesa
    pango
    wayland
    wayland-protocols
  ];

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace GIT_COMMIT_HASH '"${src.rev}"'
  '';

  preConfigure = ''
    make protocols
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m755 ./hyprpaper $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/hyprwm/hyprpaper";
    description = "A blazing fast wayland wallpaper utility";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wozeparrot ];
  };
}
