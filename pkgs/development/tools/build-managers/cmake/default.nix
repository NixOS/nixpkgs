{fetchurl, stdenv, replace, ncurses}:

stdenv.mkDerivation rec {
  name = "cmake-2.6.4";

  # We look for cmake modules in .../share/cmake-${majorVersion}/Modules.
  majorVersion = "2.6";

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
  };

  src = fetchurl {
    url = "http://www.cmake.org/files/v${majorVersion}/${name}.tar.gz";
    sha256 = "1wpxr5x4aggaqrqzjq3kg4hh09f0vyr1njik1pad01bvwd923pcw";
  };

  patches = [ ./findqt4.patch ];

  postUnpack = ''
    dontUseCmakeConfigure=1
    source $setupHook
    fixCmakeFiles $sourceRoot
    echo 'SET (CMAKE_SYSTEM_PREFIX_PATH "'${ncurses}'" CACHE FILEPATH "Root for libs for cmake" FORCE)' > $sourceRoot/cmakeInit.txt
  '';

  configureFlags= [ " --init=cmakeInit.txt " ];

  postInstall = "fixCmakeFiles $out/share";
}
