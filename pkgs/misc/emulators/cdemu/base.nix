{ pkgName, version, pkgSha256 }:
{ stdenv, fetchurl, cmake, pkgconfig, buildInputs, drvParams ? {} }:
let name = "${pkgName}-${version}";
in stdenv.mkDerivation ({
  inherit name buildInputs;
  src = fetchurl {
    url = "mirror://sourceforge/cdemu/${name}.tar.bz2";
    sha256 = pkgSha256;
  };
  nativeBuildInputs = [ pkgconfig cmake ];
  setSourceRoot = ''
    mkdir build
    cd build
    sourceRoot="`pwd`"
  '';
  configurePhase = ''
    cmake ../${name} -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_BUILD_TYPE=Release -DCMAKE_SKIP_RPATH=ON
  '';
  meta = with stdenv.lib; {
    description = "A suite of tools for emulating optical drives and discs";
    longDescription = ''
      CDEmu consists of:

      - a kernel module implementing a virtual drive-controller
      - libmirage which is a software library for interpreting optical disc images
      - a daemon which emulates the functionality of an optical drive+disc
      - textmode and GTK clients for controlling the emulator
      - an image analyzer to view the structure of image files

      Optical media emulated by CDemu can be mounted within Linux. Automounting is also allowed.
    '';
    homepage = http://cdemu.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ "Rok Mandeljc <mrok AT users DOT sourceforge DOT net>" ];
  };
} // drvParams)
