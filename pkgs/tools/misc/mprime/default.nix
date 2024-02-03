{ stdenv, lib, fetchurl, unzip, boost, curl, hwloc, gmp }:

let
  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  srcDir = {
    x86_64-linux = "linux64";
    i686-linux = "linux";
    x86_64-darwin = "macosx64";
  }."${stdenv.hostPlatform.system}" or throwSystem;

  gwnum = {
    x86_64-linux = "make64";
    i686-linux = "makefile";
    x86_64-darwin = "makemac";
  }."${stdenv.hostPlatform.system}" or throwSystem;
in

stdenv.mkDerivation rec {
  pname = "mprime";
  version = "30.8b15";

  src = fetchurl {
    url = "https://www.mersenne.org/ftp_root/gimps/p95v${lib.replaceStrings ["."] [""] version}.source.zip";
    hash = "sha256-CNYorZStHV0aESGX9LfLZ4oD5PFR2UOFLN1MiLaKw58=";
  };

  postPatch = ''
    sed -i ${srcDir}/makefile \
      -e 's/^LFLAGS =.*//'
    substituteInPlace ${srcDir}/makefile \
      --replace '-Wl,-Bstatic'  "" \
      --replace '-Wl,-Bdynamic' ""
  '';

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  buildInputs = [ boost curl hwloc gmp ];

  enableParallelBuilding = true;

  buildPhase = ''
    make -C gwnum -f ${gwnum}
    make -C ${srcDir}
  '';

  installPhase = ''
    install -Dm555 -t $out/bin ${srcDir}/mprime
  '';

  meta = with lib; {
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
    license = licenses.unfree;
    # Untested on linux-32 and osx. Works in theory.
    platforms = ["i686-linux" "x86_64-linux" "x86_64-darwin"];
    mainProgram = "mprime";
  };
}
