{ cmake, fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "pcm";
<<<<<<< HEAD
  version = "202307";
=======
  version = "202302";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-GeLiJT5AwsMWw0ErdwD6C1jtUZjUxGw5GRSvenu3W18=";
=======
    hash = "sha256-69wdA6/bRN5gYl02GgA8mXnXxVZlHIGkhtC8vFKZVcA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Processor counter monitor";
    homepage = "https://www.intel.com/software/pcm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ roosemberth ];
    platforms = [ "x86_64-linux" ];
  };
}
