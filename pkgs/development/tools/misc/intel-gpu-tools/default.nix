{ stdenv, fetchurl, pkgconfig, libdrm, libpciaccess, cairo, dri2proto, udev, libX11, libXext, libXv, libXrandr, glib, bison }:

stdenv.mkDerivation rec {
  name = "intel-gpu-tools-1.10";

  src = fetchurl {
    url = "http://xorg.freedesktop.org/archive/individual/app/${name}.tar.bz2";
    sha256 = "0x4q7gv14yaniycgdxym9nazlj6wzcvjjhg40bbm5lkw5pqvxwkd";
  };

  buildInputs = [ pkgconfig libdrm libpciaccess cairo dri2proto udev libX11 libXext libXv libXrandr glib bison ];

  meta = with stdenv.lib; {
    homepage = https://01.org/linuxgraphics/;
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
