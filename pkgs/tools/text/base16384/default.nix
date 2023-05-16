{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "base16384";
<<<<<<< HEAD
  version = "2.2.5";
=======
  version = "2.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fumiama";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-S9DA9C+6OJcSLJTSLRo9rolJO9yVQ0FOE7uwbvmJiGk=";
=======
    hash = "sha256-5Dfu88aAVtpNAwHAo+LOxe+jpgDhNdHYkWex42dCK0s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Encode binary files to printable utf16be";
    homepage = "https://github.com/fumiama/base16384";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
  };
}
