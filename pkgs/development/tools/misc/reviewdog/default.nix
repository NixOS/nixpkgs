{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0n7hk3va25ym8sb900i1s1hjszgwrfl7gfsjbj1m330fidh3q6jc";
  };

  vendorSha256 = "0xscirzi0gqww33ngwh29jiylarj0w5snn9kvv43wfrphb6c79s5";

  doCheck = false;

  subPackages = [ "cmd/reviewdog" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/reviewdog/reviewdog/commands.Version=${version}" ];

  meta = with lib; {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    homepage = "https://github.com/reviewdog/reviewdog";
    changelog = "https://github.com/reviewdog/reviewdog/releases/tag/v${version}";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
