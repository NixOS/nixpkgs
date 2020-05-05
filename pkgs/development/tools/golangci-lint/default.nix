{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "1xw6m4ps6yw8gnkwy8v7rrz2b8c8n72cd7vkpx481dkd36vccpkc";
  };

  modSha256 = "0xgnimr1jydrgwhbyjaz710kx3m3505nhy5cs10p501qxbnzkjf9";
  subPackages = [ "cmd/golangci-lint" ];

  meta = with lib; {
    description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = "https://golangci.com/";
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ anpryl manveru ];
  };
}
