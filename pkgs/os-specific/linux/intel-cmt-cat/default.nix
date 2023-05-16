{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "23.08";
=======
  version = "4.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "intel-cmt-cat";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-cmt-cat";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-T97cTJLGSJgOoQFgL/lI+AldqsCEcHilhTTDZy+pmU8=";
=======
    sha256 = "sha256-gjJtwEDvPW0JDwlIUXSmv1wm4TknKsE/BLKHiqIgjho=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" "NOLDCONFIG=y" ];

  meta = with lib; {
    description = "User space software for Intel(R) Resource Director Technology";
    homepage = "https://github.com/intel/intel-cmt-cat";
    license = licenses.bsd3;
    maintainers = with maintainers; [ arkivm ];
    platforms = [ "x86_64-linux" ];
  };
}
