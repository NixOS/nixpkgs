{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  name = "golangci-lint-${version}";
  version = "1.16.0";
  goPackagePath = "github.com/golangci/golangci-lint";

  subPackages = [ "cmd/golangci-lint" ];

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "1yzcfmrxyrxhq3vx13qm7czvhvdnaqay75v8ry1lgpg0bnh9pakx";
  };

  modSha256 = "1dsaj6qsac9y4rkssjbmk46vaqbblzdim2rbdh3dgn1m0vdpv505";

  meta = with lib; {
    description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = https://golangci.com/;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ anpryl manveru ];
  };
}
