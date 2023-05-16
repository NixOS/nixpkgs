{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "upx";
<<<<<<< HEAD
  version = "4.1.0";
=======
  version = "4.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "upx";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    sha256 = "sha256-pHJypO+sK7+ytM7yJxJpfBJHTYpGc9nr/JiFGd7hlJM=";
=======
    sha256 = "sha256-5jqEdMlHmsD88kT/EGieL7DktppVdfWyJWGRNRKbRc4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://upx.github.io/";
    description = "The Ultimate Packer for eXecutables";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
