{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.25.1";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "04r26nn72myacs6v2jq8mi4kjik82iwsh6w59h4k9yk0my3fjwia";
  };

  modSha256 = "1pz5f2hv2lssiwsp60hsycg2ijyafb7r5fl2yrvflqg547k3n8x2";
  subPackages = [ "cmd/golangci-lint" ];

  meta = with lib; {
    description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = "https://golangci.com/";
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ anpryl manveru ];
  };
}
