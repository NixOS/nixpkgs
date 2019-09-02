{ stdenv, fetchurl, cmake, javac }:

stdenv.mkDerivation rec {
  pname = "hdf-java";
  version = "3.3.2";

  src = fetchurl {
    url = "http://www.hdfgroup.org/ftp/HDF5/releases/HDF-JAVA/hdfjni-${version}/src/CMake-hdfjava-${version}.tar.gz";
    sha256 = "0m1gp2aspcblqzmpqbdpfp6giskws85ds6p5gz8sx7asyp7wznpr";
  };

  nativeBuildInputs = [ cmake javac ];

  dontConfigure = true;
  buildPhase = "./build-hdfjava-unix.sh";
  installPhase = ''
    mkdir -p $out
    cp -r build/_CPack_Packages/Linux/TGZ/HDFJava-3.3.2-Linux/HDF_Group/HDFJava/${version}/* $out/
  '';

  meta = {
    description = "A Java package that implements HDF4 and HDF5 data objects in an object-oriented form";
    license = stdenv.lib.licenses.free; # BSD-like
    homepage = https://support.hdfgroup.org/products/java/index.html;
    platforms = stdenv.lib.platforms.linux;
  };
}
