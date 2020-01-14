{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.22.2";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    sha256 = "1wwp6ppm5p2cf7jbcgmqm6alzaj34sa079d98afw21yr81qxvvid";
  };

  modSha256 = "02j2cf5778ds0vwz0kkd9c1x5ap732vkq20bfg440spfajscvndm";
  subPackages = [ "cmd/golangci-lint" ];

  meta = with lib; {
    description = "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = https://golangci.com/;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ anpryl manveru ];
  };
}
