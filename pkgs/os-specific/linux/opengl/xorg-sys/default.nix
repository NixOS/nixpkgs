# This is a very dirty hack to allow hardware acceleration of OpenGL
# applications for most (?) users.  It will use the driver that your
# Linux distribution installed in /usr/lib/libGL.so.1.  Hopefully,
# this driver uses hardware acceleration.
#
# Of course, use of the driver in /usr/lib is highly impure.  But it
# might actually work ;-)

{stdenv, xlibs, expat}:

stdenv.mkDerivation {
  name = "xorg-sys-opengl";
  builder = ./builder.sh;
  neededLibs = [xlibs.libXxf86vm xlibs.libXext expat];
}
