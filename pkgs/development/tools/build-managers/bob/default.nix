{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bob";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "benchkram";
    repo = pname;
    rev = version;
    hash = "sha256-jZDyZVjo4Purt2tabJew5N4MZmLXli6gqBTejv5FGJM=";
  };

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  vendorHash = "sha256-dmMoFyl9IX0QS6sNC6qzC4DQQQfvxmxuUeUfx0DBd/I=";

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
