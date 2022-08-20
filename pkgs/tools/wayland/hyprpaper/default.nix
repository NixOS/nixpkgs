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
  version = "unstable-2022-07-04";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = pname;
    rev = "e15912e9817d79bb988085c88e313fac5ab60940";
    sha256 = "sha256-UZSRcj+CckUDllBtmlIcwA+xXUonpJZl3zC151IV3f0=";
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
