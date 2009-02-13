{fetchurl, stdenv, replace, ncurses}:

stdenv.mkDerivation rec {
  name = "cmake-2.6.2";

  # We look for cmake modules in .../share/cmake-${majorVersion}/Modules.
  majorVersion = "2.6"; 
  
  setupHook = ./setup-hook.sh;
  
  meta = {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
  };
  
  src = fetchurl {
    url = "http://www.cmake.org/files/v2.6/${name}.tar.gz";
    sha256 = "b3f5a9dfa97fb82cb1b7d78a62d949f93c8d4317af36674f337d27066fa6b7e9";
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
