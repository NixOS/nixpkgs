{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, makeWrapper
, meson
, ninja
, libjpeg
, libpng
, xorg
, libX11
, libGL
, libdrm
, udev
, wayland
, wayland-protocols
, mesa
}:

stdenv.mkDerivation rec {
  pname = "glmark2";
  version = "2023.01";

  src = fetchFromGitHub {
    owner = "glmark2";
    repo = "glmark2";
    rev = version;
    sha256 = "sha256-WCvc5GqrAdpIKQ4LVqwO6ZGbzBgLCl49NxiGJynIjSQ=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper meson ninja ];
  buildInputs = [
    libjpeg
    libpng
    xorg.libxcb
    libX11
    libdrm
    udev
    wayland
    wayland-protocols
    mesa
  ];

  mesonFlags = [ "-Dflavors=x11-gl,x11-glesv2,drm-gl,drm-glesv2,wayland-gl,wayland-glesv2" ];

  postInstall = ''
    for binary in $out/bin/glmark2*; do
      wrapProgram $binary \
        --set LD_LIBRARY_PATH ${libGL}/lib
    done
  '';

  meta = with lib; {
    description = "OpenGL (ES) 2.0 benchmark";
    homepage = "https://github.com/glmark2/glmark2";
    license = licenses.gpl3Plus;
    longDescription = ''
      glmark2 is a benchmark for OpenGL (ES) 2.0. It uses only the subset of
      the OpenGL 2.0 API that is compatible with OpenGL ES 2.0.
    '';
    platforms = platforms.linux;
    maintainers = [ maintainers.wmertens ];
  };
}
