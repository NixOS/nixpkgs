{ lib, stdenv, fetchFromSourcehut, meson, ninja, pkg-config, wlroots, wayland, wayland-protocols
, libX11, libGL }:

stdenv.mkDerivation rec {
  pname = "glpaper";
  version = "unstable-2020-10-11";

  src = fetchFromSourcehut {
    owner = "~scoopta";
    repo = pname;
    vc = "hg";
    rev = "9e7ec7cd270af330039c395345c7d23c04682267";
    sha256 = "sha256-yBHRg6eg+PK/ixuM0MBty3RJY9qcemr3Dt+8SAitqnk=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [
    wayland
    libX11 # required by libglvnd
    libGL
  ];

  meta = with lib; {
    description =
      "Wallpaper program for wlroots based Wayland compositors such as sway that allows you to render glsl shaders as your wallpaper";
    homepage = "https://hg.sr.ht/~scoopta/glpaper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ccellado ];
  };
}
