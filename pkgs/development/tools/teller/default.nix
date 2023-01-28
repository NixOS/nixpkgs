{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "teller";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "tellerops";
    repo = "teller";
    rev = "v${version}";
    sha256 = "sha256-vgrfWKKXf4C4qkbGiB3ndtJy1VyTx2NJs2QiOSFFZkE=";
  };

  # The package includes vendor folder
  vendorSha256 = null;

  tags = ["heroku" "go" "golang" "aws" "vault" "secret-management" "secrets" "hashicorp" "gce" "cyberark" "conjur"];

  buildPhase = ''
    mkdir -p $out/bin
    go build -ldflags "-s -w -X main.version=${version} -X main.commit=0000000000000000000000000000000000000000 -X main.date=1970-01-01" -o $out/bin
  '';
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tellerops/teller";
    description = "Cloud native secrets management for developers - never leave your command line for secrets. ";
    maintainers = with maintainers; [ mrityunjaygr8 ];
    license = licenses.asl20;
    mainProgram = "teller";
  };
}
