{stdenv, fetchurl, x11, mesa}:

let version = "8.0.1"; in

stdenv.mkDerivation {
  name = "glxinfo-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/demos/${version}/mesa-demos-${version}.tar.bz2";
    sha256 = "1lbp1llpx0hl5k79xb653yvjvk9mlikj73r8xjzyxqqp1nrg5isb";
  };

  buildInputs = [x11 mesa];

  configurePhase = "true";

  buildPhase = "
    cd src/xdemos
    gcc glxinfo.c -o glxinfo -lGL -lX11
    gcc glxgears.c -o glxgears -lGL -lX11
  ";

  installPhase = "
    mkdir -p $out/bin
    cp glxinfo glxgears $out/bin/
  ";
}
