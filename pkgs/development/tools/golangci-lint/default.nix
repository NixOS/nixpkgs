{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.27.0";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "1capiw8af4wmx3wpfslb30xivfyh72x5kj12f8p5pwhl6id31931";
  };

  vendorSha256 = "16wr8ixicbvdpg5mg6q07sa1b03ydpwdbvbjl3r9qihdqkhhzlr1";
  subPackages = [ "cmd/golangci-lint" ];

  meta = with lib; {
    description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = "https://golangci.com/";
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ anpryl manveru ];
  };
}
