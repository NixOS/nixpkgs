{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.23.8";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "166pwgf86lkd277dq98vjry0ad0avrz12zxb9rfgbhl1z4ccwi1g";
  };

  modSha256 = "0sckz298bvkf4p4fdmsmza0zrj2s2pvc86qwg6i76vdh9yzvq5gx";
  subPackages = [ "cmd/golangci-lint" ];

  meta = with lib; {
    description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = "https://golangci.com/";
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ anpryl manveru ];
  };
}
