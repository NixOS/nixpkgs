<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "stress";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = pname;
    rev = version;
    hash = "sha256-1r0n/KE4RpO0txIViGxuc7G+I4Ds9AJYcuMx2/R97jg=";
  };

  nativeBuildInputs = [ autoreconfHook ];

=======
{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "stress";
  version = "1.0.4";

  src = fetchurl {
    url = "https://people.seas.harvard.edu/~apw/stress/stress-${version}.tar.gz";
    sha256 = "0nw210jajk38m3y7h8s130ps2qsbz7j75wab07hi2r3hlz14yzh5";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Simple workload generator for POSIX systems. It imposes a configurable amount of CPU, memory, I/O, and disk stress on the system";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
