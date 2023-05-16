{lib, stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "uftrace";
<<<<<<< HEAD
  version = "0.14";
=======
  version = "0.13.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "namhyung";
    repo = "uftrace";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-f0R3EbLd0sJ1kcsRquFZRrl8jXi0msIz2SZ0oJzoWUE=";
=======
    sha256 = "sha256-hpEExyvazCH+lNTK0Ej0zbnWyX0gVLPjM9XfOuAueis=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postUnpack = ''
        patchShebangs .
  '';

  meta = {
    description = "Function (graph) tracer for user-space";
    homepage = "https://github.com/namhyung/uftrace";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [lib.maintainers.nthorne];
  };
}
