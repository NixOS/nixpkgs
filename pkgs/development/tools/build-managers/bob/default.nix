{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bob";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "benchkram";
    repo = pname;
    rev = version;
    hash = "sha256-Bq/BL45EN4h7eV1glCkuVqUhZCrDS5b5mVg6JJxlTD4=";
  };

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  vendorHash = "sha256-jakmXkDHjcA1BOIorrP2ZukcJhosbkJoC+Y/+wAPBCc=";

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
