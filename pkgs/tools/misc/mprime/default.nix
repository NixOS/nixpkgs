{ stdenv, lib, fetchurl, unzip, curl, hwloc, gmp }:

let
  srcDir =
    if stdenv.hostPlatform.system == "x86_64-linux" then "linux64"
    else if stdenv.hostPlatform.system == "i686-linux" then "linux"
    else if stdenv.hostPlatform.system == "x86_64-darwin" then "macosx64"
    else throwSystem;
  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";
  gwnum =
    if stdenv.hostPlatform.system == "x86_64-linux" then "make64"
    else if stdenv.hostPlatform.system == "i686-linux" then "makefile"
    else if stdenv.hostPlatform.system == "x86_64-darwin" then "makemac"
    else throwSystem;
in

stdenv.mkDerivation rec {
  name = "mprime-${version}";
  version = "29.4b7";

  src = fetchurl {
    url = "https://www.mersenne.org/ftp_root/gimps/p95v${lib.replaceStrings ["."] [""] version}.source.zip";
    sha256 = "0idaqm46m4yis7vl014scx57lpccvjbnyy79gmj8caxghyajws0m";
  };

  unpackCmd = "unzip -d src -q $curSrc || true";

  nativeBuildInputs = [ unzip ];
  buildInputs = [ curl hwloc gmp ];

  patches = [ ./makefile.patch ];

  buildPhase = ''
    make -C gwnum -f ${gwnum}
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
    homepage = "https://www.mersenne.org/";
    # Unfree, because of a license requirement to share prize money if you find
    # a suitable prime. http://www.mersenne.org/legal/#EULA
    license = stdenv.lib.licenses.unfree;
    # Untested on linux-32 and osx. Works in theory.
    platforms = ["i686-linux" "x86_64-linux" "x86_64-darwin"];
  };
}
