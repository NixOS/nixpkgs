{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.17.1";
  goPackagePath = "github.com/golangci/golangci-lint";

  subPackages = [ "cmd/golangci-lint" ];

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "1hs24nimv11c63a90ds8ps1lli16m3apsbrd9vpbq2rmxdbpwqac";
  };

  modSha256 = "0k0831rg6ygjffrq5y9488aiacskky7g6bvsfrgfz0g7i0mig1n6";

  meta = with lib; {
    description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = https://golangci.com/;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ anpryl manveru ];
  };
}
