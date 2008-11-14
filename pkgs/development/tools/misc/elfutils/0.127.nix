args: with args;

stdenv.mkDerivation {
  name = "elfutils-"+version;
  src = fetchurl {
    url = http://nixos.org/tarballs/elfutils-0.127.tar.gz;
    sha256 = "12n3h5r3c24a6l2wxz0w2dqq072bvgms0dzckivrwp5vdn22lpdv";
  };
  preBuild = "sed -e 's/-Werror//' -i */Makefile ";
  dontAddDisableDepTrack = "true";
}
