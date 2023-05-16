<<<<<<< HEAD
{ lib, stdenv, fetchurl, buildPackages }:

stdenv.mkDerivation rec {
  pname = "mawk";
  version = "1.3.4-20230525";
=======
{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mawk";
  version = "1.3.4-20230203";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/mawk/mawk-${version}.tgz"
      "https://invisible-mirror.net/archives/mawk/mawk-${version}.tgz"
    ];
<<<<<<< HEAD
    sha256 = "sha256-VjnRS7kSQ3Oz1/lX0rklrYrZZW1GISw/I9vKgQzJJp8=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

=======
    sha256 = "sha256-bbejKsecURB60xpAfU+SxrhC3eL2inUztOe3sD6JAL4=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Interpreter for the AWK Programming Language";
    homepage = "https://invisible-island.net/mawk/mawk.html";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; unix;
  };
}
