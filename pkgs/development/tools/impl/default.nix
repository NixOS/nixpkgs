{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "impl";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "josharian";
    repo = "impl";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BqRoLh0MpNQgY9OHHRBbegWGsq3Y4wOqg94rWvex76I=";
  };

  vendorHash = "sha256-+5+CM5iGV54zRa7rJoQDBWrO98icNxlAv8JwATynanY=";
=======
    sha256 = "sha256-OztQR1NusP7/FTm5kmuSSi1AC47DJFki7vVlPQIl6+8=";
  };

  vendorSha256 = "sha256-+5+CM5iGV54zRa7rJoQDBWrO98icNxlAv8JwATynanY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preCheck = ''
    export GOROOT="$(go env GOROOT)"
  '';

  meta = with lib; {
    description = "Generate method stubs for implementing an interface";
    homepage = "https://github.com/josharian/impl";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
