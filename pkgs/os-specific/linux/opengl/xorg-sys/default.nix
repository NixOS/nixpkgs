# This is a very dirty hack to allow hardware acceleration of OpenGL
# applications for most (?) users.  It will use the driver that your
# Linux distribution installed in /usr/lib/libGL.so.1.  Hopefully,
# this driver uses hardware acceleration.
#
# Of course, use of the driver in /usr/lib is highly impure.  But it
# might actually work ;-)

{stdenv, xorg, expat, libdrm}:

stdenv.mkDerivation {
  name = "xorg-sys-opengl-3";
  builder = ./builder.sh;
  neededLibs = map (p: p.out)
    [xorg.libXxf86vm xorg.libXext expat libdrm stdenv.cc.cc];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
