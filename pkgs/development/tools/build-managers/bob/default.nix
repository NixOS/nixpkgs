{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bob";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "benchkram";
    repo = pname;
    rev = version;
    hash = "sha256-Mt98+EPATNarKx6qZJzx6eIyPYymZfiTntg6/e7g/vw=";
  };

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  vendorHash = "sha256-S1XUgjdSVTWXehOLCxXcvj0SH12cxqvYadVlCw/saF4=";

  excludedPackages = [ "example/server-db" "test/e2e" "tui-example" ];

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "A build system for microservices";
    homepage = "https://bob.build";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zuzuleinen ];
  };
}
