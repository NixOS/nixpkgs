{ stdenv, fetchhg, meson, ninja, pkg-config, wlroots, wayland, wayland-protocols
, libX11, libGL }:

stdenv.mkDerivation {
  name = "glpaper";
  version = "unstable-2020-03-30";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/glpaper";
    rev = "a95db77088dfb5636a87f3743fc9b5eca70c1ae2";
    sha256 = "04y12910wvhy4aqx2sa63dy9l6nbs7b77yqpdhc96x2b3mgzgjfs";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [
    wayland
    libX11 # required by libglvnd
    libGL
  ];

  meta = with stdenv.lib; {
    description =
      "Wallpaper program for wlroots based Wayland compositors such as sway that allows you to render glsl shaders as your wallpaper";
    homepage = "https://hg.sr.ht/~scoopta/glpaper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ccellado ];
  };
}
