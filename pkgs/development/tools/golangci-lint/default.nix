{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  pname = "golangci-lint";
  version = "1.21.0";
  goPackagePath = "github.com/golangci/golangci-lint";

  subPackages = [ "cmd/golangci-lint" ];

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "0knvb59mg9jrzmfs5nzglz4nv047ayq1xz6dkis74wl1g9xi6yr5";
  };

  meta = with lib; {
    description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = https://golangci.com/;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ anpryl manveru ];
  };
}
