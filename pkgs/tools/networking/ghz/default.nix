{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghz";
  version = "0.115.0";

  src = fetchFromGitHub {
    owner = "bojand";
    repo = "ghz";
    rev = "v${version}";
    sha256 = "sha256-Y/RvXBE2+ztAPJrSBek1APkN7F3LIWAz13TGQUgFzR0=";
  };

  vendorHash = "sha256-BTfdKH2FBfIeHOG4dhOopoPQWHjhlJstQWWOkMwEOGs=";

  subPackages = [ "cmd/ghz" "cmd/ghz-web" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Simple gRPC benchmarking and load testing tool";
    homepage = "https://ghz.sh";
    license = licenses.asl20;
    maintainers = [ maintainers.zombiezen ];
  };
}
