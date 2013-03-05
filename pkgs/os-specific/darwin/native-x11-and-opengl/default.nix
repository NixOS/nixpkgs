{ stdenv, writeScript }:

assert stdenv.isDarwin;

stdenv.mkDerivation rec {
  name = "darwin-native-x11-and-opengl";

  builder = writeScript "${name}-builder.sh" ''
    /bin/mkdir -p $out
    /bin/ln -sv /usr/X11/{bin,lib,include,share} $out/
  '';
}
