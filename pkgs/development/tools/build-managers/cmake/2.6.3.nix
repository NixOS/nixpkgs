{fetchurl, stdenv, replace, ncurses}:

stdenv.mkDerivation rec {
  name = "cmake-2.6.3-RC-15";

  # We look for cmake modules in .../share/cmake-${majorVersion}/Modules.
  majorVersion = "2.6";

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
  };

  src = fetchurl {
    url = "http://www.cmake.org/files/v2.6/${name}.tar.gz";
    sha256 = "476b6daca63c39bc46955f99f2566735d51159c43ccc716fa689ba2a2fa7e432";
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
