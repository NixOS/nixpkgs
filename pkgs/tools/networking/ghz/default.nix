<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, testers, ghz }:

buildGoModule rec {
  pname = "ghz";
  version = "0.117.0";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghz";
  version = "0.115.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bojand";
    repo = "ghz";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-aAqbSPcz7qQID4H0Vu3VTnbECvlj+We9K5F656k9jTw=";
  };

  vendorHash = "sha256-jtzCOF5TAHv3PiGxBx65IR/3x6JpqMzsWW8amab8hqQ=";

  subPackages = [ "cmd/ghz" "cmd/ghz-web" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = ghz;
    };
    web-version = testers.testVersion {
      package = ghz;
      command = "ghz-web -v";
    };
  };
=======
    sha256 = "sha256-Y/RvXBE2+ztAPJrSBek1APkN7F3LIWAz13TGQUgFzR0=";
  };

  vendorHash = "sha256-BTfdKH2FBfIeHOG4dhOopoPQWHjhlJstQWWOkMwEOGs=";

  subPackages = [ "cmd/ghz" "cmd/ghz-web" ];

  ldflags = [ "-s" "-w" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Simple gRPC benchmarking and load testing tool";
    homepage = "https://ghz.sh";
    license = licenses.asl20;
    maintainers = [ maintainers.zombiezen ];
  };
}
