{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.23.6";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "0y5kjlqbz9xxlxd8kagrsyz9wvjqf7i28i6zb2m8x9c9zg82kvsn";
  };

  modSha256 = "0sckz298bvkf4p4fdmsmza0zrj2s2pvc86qwg6i76vdh9yzvq5gx";
  subPackages = [ "cmd/golangci-lint" ];

  meta = with lib; {
    description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = https://golangci.com/;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ anpryl manveru ];
  };
}
