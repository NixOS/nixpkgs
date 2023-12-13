{ lib, buildGoModule, fetchFromGitHub, testers, ghz }:

buildGoModule rec {
  pname = "ghz";
  version = "0.117.0";

  src = fetchFromGitHub {
    owner = "bojand";
    repo = "ghz";
    rev = "v${version}";
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

  meta = with lib; {
    description = "Simple gRPC benchmarking and load testing tool";
    homepage = "https://ghz.sh";
    license = licenses.asl20;
    maintainers = [ maintainers.zombiezen ];
  };
}
