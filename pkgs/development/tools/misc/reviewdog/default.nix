{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.9.17";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0fm7avkc8izs0a9lqshibzpl08g4l3w38ayw7g521p23aq90q3c9";
  };

  modSha256 = "1jf08g0xr4wknh9x15igq73y02cy2faqjdjs2v842ii4p3n4p9dw";

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
