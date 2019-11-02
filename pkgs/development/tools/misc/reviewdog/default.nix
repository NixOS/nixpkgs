{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.9.12";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0r7y8nbpwfbvinpapv6lgnlc93kwn4b6722cp5ihyf361fklcd02";
  };

  modSha256 = "1ydfirjhw238zbia5mk90fx9rrg3kvm2h54zjhiimlvnpls5y8c9";

  subPackages = [ "cmd/reviewdog" ];

  buildFlagsArray = [ "-ldflags=-X github.com/reviewdog/reviewdog/commands.Version=${version}" ];

  meta = with lib; {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    homepage = "https://github.com/reviewdog/reviewdog";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
