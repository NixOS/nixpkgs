{stdenv, fetchurl, xlibsWrapper, mesa}:

let version = "8.1.0"; in

stdenv.mkDerivation {
  name = "glxinfo-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/demos/${version}/mesa-demos-${version}.tar.bz2";
    sha256 = "0a58hw5850731p4smz4zqsbvyxvgjf7n5xdbs9l1wamk8q3gl0wp";
  };

  buildInputs = [xlibsWrapper mesa];

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
