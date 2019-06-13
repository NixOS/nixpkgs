{ stdenv, fetchFromGitHub, pkgconfig, libjpeg, libpng, xorg, libX11, libGL, libdrm,
  python27, wayland, udev, mesa_noglu, wafHook }:

stdenv.mkDerivation rec {
  name = "glmark2-${version}";
  version = "2017-09-01";

  src = fetchFromGitHub {
    owner = "glmark2";
    repo = "glmark2";
    rev = "7265e8e6c77c4f60302507eca0e18560b1117a86";
    sha256 = "076l75rfl6pnp1wgiwlaihy1vg2advg1z8bi0x84kk259kldgvwn";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [
    libjpeg libpng xorg.libxcb libX11 libGL libdrm python27 wayland udev mesa_noglu
  ];

  wafConfigureFlags = ["--with-flavors=x11-gl,x11-glesv2,drm-gl,drm-glesv2,wayland-gl,wayland-glesv2"];

  meta = with stdenv.lib; {
    description = "OpenGL (ES) 2.0 benchmark";
    homepage = https://github.com/glmark2/glmark2;
    license = licenses.gpl3Plus;
    longDescription = ''
      glmark2 is a benchmark for OpenGL (ES) 2.0. It uses only the subset of
      the OpenGL 2.0 API that is compatible with OpenGL ES 2.0.
    '';
    platforms = platforms.linux;
    maintainers = [ maintainers.wmertens ];
  };
}
