{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "vtm";
<<<<<<< HEAD
  version = "0.9.9t";
=======
  version = "0.9.9h";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "netxs-group";
    repo = "vtm";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-WbigrJohLYCRvgsCNd4Cid1zGaP1aQbj59QhZ6ymLms=";
=======
    sha256 = "sha256-6JyOoEJoJ/y6pXfhQV4nei2NAOCClScFDscwqNPKZu8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "../src" ];

  meta = with lib; {
    description = "Terminal multiplexer with window manager and session sharing";
    homepage = "https://vtm.netxs.online/";
    license = licenses.mit;
<<<<<<< HEAD
    platforms = platforms.all;
=======
    platforms = [ "x86_64-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ ahuzik ];
  };
}
