{ stdenv, fetchFromGitHub, pkgconfig, libjpeg, libpng, xorg, libX11, mesa, libdrm, python27, wayland }:

stdenv.mkDerivation rec {
  name = "glmark2-${version}";
  version = "2015-06-11";

  src = fetchFromGitHub {
    owner = "glmark2";
    repo = "glmark2";
    rev = "fa71af2dfab711fac87b9504b6fc9862f44bf72a";
    sha256 = "1razwrmwk94wf8y7rnqpas9520gidixzcwa65pg946n823105znw";
  };

  buildInputs = [
    pkgconfig libjpeg libpng xorg.libxcb libX11 mesa libdrm python27 wayland
  ];

  buildPhase = ''
    python ./waf configure --prefix=$out --with-flavors x11-gl,x11-glesv2,drm-gl,drm-glesv2,wayland-gl,wayland-glesv2
    python2 ./waf
  '';

  installPhase = ''
    python2 ./waf install --destdir="$pkgdir/"
  '';

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
