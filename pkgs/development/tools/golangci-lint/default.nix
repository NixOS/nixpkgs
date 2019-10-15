{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  pname = "golangci-lint";
  version = "1.20.0";
  goPackagePath = "github.com/golangci/golangci-lint";

  subPackages = [ "cmd/golangci-lint" ];

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "1ca7l8smi1hx2sk6sq1cac9bvij4wnxxmwldbk8r1ih8ja5i6vdk";
  };

  meta = with lib; {
    description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = https://golangci.com/;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ anpryl manveru ];
  };
}
