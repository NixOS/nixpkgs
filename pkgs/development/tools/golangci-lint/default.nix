{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  name = "golangci-lint-${version}";
  version = "1.9.2";
  goPackagePath = "github.com/golangci/golangci-lint";

  subPackages = [ "cmd/golangci-lint" ];

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "0r05j6ayk5778fkd5r1sgcwq675ra0vq82lqs125g70291ryha08";
  };

  meta = with lib; {
    description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = https://golangci.com/;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.manveru ];
  };
}
