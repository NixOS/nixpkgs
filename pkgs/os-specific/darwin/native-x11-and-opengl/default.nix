{ stdenv, writeScript }:

stdenv.mkDerivation rec {
  name = "darwin-native-x11-and-opengl";

  builder = writeScript "${name}-builder.sh" ''
    /bin/mkdir -p $out
    /bin/mkdir $out/lib
    /bin/ln -sv /usr/X11/lib/{*.dylib,X11,xorg} $out/lib
    /bin/mkdir $out/lib/pkgconfig
    /bin/ln -sv /usr/X11/lib/pkgconfig/{x*.pc,gl*.pc} $out/lib/pkgconfig
    /bin/ln -sv /usr/X11/{bin,include,share} $out/
  '';
}
