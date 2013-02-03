{ stdenv, fetchsvn, which } :

stdenv.mkDerivation rec {
  name = "winetricks";

  src = fetchsvn {
    url = "http://winetricks.googlecode.com/svn/trunk";
    rev = "r934";
  };

  patch = ./winetricks.patch;

  builder = ./build_winetricks.sh;
}

