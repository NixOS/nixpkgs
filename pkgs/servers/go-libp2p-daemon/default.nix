{ lib, buildGoModule, fetchFromGitHub }:

<<<<<<< HEAD
buildGoModule rec {
  pname = "go-libp2p-daemon";
  version = "0.5.0";
=======
buildGoModule {
  pname = "go-libp2p-daemon";
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "libp2p";
    repo = "go-libp2p-daemon";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-3zlSD+9KnIOBlaE3gCTBGKwZY0rMW8lbb4b77BlJm/g=";
  };

  vendorHash = "sha256-8wrtPfuZ9X3cKjDeywht0d3p5lQouk6ZPO1PIjBz2Ro=";
=======
    rev = "bfa207ed34c27947f0828a4ae8d10bda62aa49a9";
    sha256 = "1f3gjkmpqngajjpijpjdmkmsjfm9bdgakb5r28fnc6w9dmfyj51x";
  };

  vendorSha256 = "0g25r7wd1hvnwxxq18mpx1r1wig6dnlnvzkpvgw79q6nymxlppmv";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/libp2p/go-libp2p-daemon";
    license = licenses.mit;
    maintainers = with maintainers; [ fare ];
  };
}
