{ stdenv, fetchurl, unzip, pkgconfig, curl }:

let
  srcDir =
    if stdenv.system == "x86_64-linux" then "linux64"
    else if stdenv.system == "i686-linux" then "linux"
    else if stdenv.system == "x86_64-darwin" then "macosx64"
    else throwSystem;
  throwSystem = throw "Unsupported system: ${stdenv.system}";
  gwnum =
    if stdenv.system == "x86_64-linux" then "make64"
    else if stdenv.system == "i686-linux" then "makefile"
    else if stdenv.system == "x86_64-darwin" then "makemac"
    else throwSystem;
in

stdenv.mkDerivation {
  name = "mprime-28.7";

  src = fetchurl {
    url = http://www.mersenne.org/ftp_root/gimps/p95v287.source.zip;
    sha256 = "1k3gxhs3g8hfghzpmidhcwpwyayj8r83v8zjai1z4xgsql4jwby1";
  };

  unpackCmd = "unzip -d src -q $curSrc";

  buildInputs = [ unzip pkgconfig curl ];

  patches = [ ./makefile.patch ];

  buildPhase = ''
    make -C gwnum -f ${gwnum}
    echo 'override CFLAGS := $(CFLAGS)' $(pkg-config --cflags libcurl) >> ${srcDir}/makefile
    echo 'override LIBS := $(LIBS)' $(pkg-config --libs libcurl) >> ${srcDir}/makefile
    make -C ${srcDir}
  '';

  installPhase = ''
    install -D ${srcDir}/mprime $out/bin/mprime
  '';
  
  meta = {
    description = "Mersenne prime search / System stability tester";
    longDescription = ''
      MPrime is the Linux command-line interface version of Prime95, to be run
      in a text terminal or in a terminal emulator window as a remote shell
      client. It is identical to Prime95 in functionality, except it lacks a
      graphical user interface.
    '';
    homepage = http://www.mersenne.org/;
    # Unfree, because of a license requirement to share prize money if you find
    # a suitable prime. http://www.mersenne.org/legal/#EULA
    license = stdenv.lib.licenses.unfree;
    # Untested on linux-32 and osx. Works in theory.
    platforms = ["i686-linux" "x86_64-linux" "x86_64-darwin"];
  };
}
