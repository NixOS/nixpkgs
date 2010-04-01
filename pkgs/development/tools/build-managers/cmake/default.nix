{fetchurl, stdenv, replace, ncurses}:

stdenv.mkDerivation rec {
  name = "cmake-2.8.0";

  # We look for cmake modules in .../share/cmake-${majorVersion}/Modules.
  majorVersion = "2.8";

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
  };

  src = fetchurl {
    url = "http://www.cmake.org/files/v${majorVersion}/${name}.tar.gz";
    sha256 = "0va7kxczqb920n61xnyhr99ajs4v05mssk4n0p6z55yvr9g62zc4";
  };

  postUnpack = ''
    dontUseCmakeConfigure=1
    source $setupHook
    fixCmakeFiles $sourceRoot
    echo 'SET (CMAKE_SYSTEM_PREFIX_PATH "'${ncurses}'" CACHE FILEPATH "Root for libs for cmake" FORCE)' > $sourceRoot/cmakeInit.txt
  '';

  configureFlags= [ " --init=cmakeInit.txt " ];

  postInstall = "fixCmakeFiles $out/share";
}
