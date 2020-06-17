{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkite-cli";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "cli";
    rev = "v${version}";
    sha256 = "05hz59qzadkk4ji5icv5sxih31pnn0abnmiwcyfa2mr3l5jaqjnd";
  };

  vendorSha256 = "0jxh3yhh0sdvaykhinxngpipk369hw8z1y3g2z4c1115m5rjp2bb";

  subPackages = [ "cmd/bk" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A command line interface for Buildkite";
    homepage = "https://github.com/buildkite/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ groodt ];
  };
}
